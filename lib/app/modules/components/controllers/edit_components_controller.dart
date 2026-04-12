import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/helpers/nullable_rx.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../common/helpers/image_helpers.dart';
import '../../../widgets/custom_snackbar.dart';

class EditComponentsController extends GetxController {
  late final String levelName;
  late final String rackName;
  late final Map<String, dynamic> component;
  late final String componentId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final FocusNode stockFocusNode = FocusNode();

  final RxBool isLoadingImage = false.obs;
  final RxBool isLoadingAddComponent = false.obs;
  final Rx<File?> imageFileController = RxNullable<File?>().setNull();
  final Rx<String?> networkImage = RxNullable<String?>().setNull();
  final RxString selectedRack = ''.obs;
  final RxString selectedLevel = ''.obs;

  String? userName;

  final unitName = 'pcs'.obs;
  final listUnit = <String>['meter', 'pcs', 'dus', 'box', 'pack', 'roll'];

  final RxInt stock = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = (Get.arguments as Map<String, dynamic>?) ?? {};

    rackName = args['rackName']?.toString() ?? '';
    levelName = args['levelName']?.toString() ?? '';
    component = Map<String, dynamic>.from(args['component'] as Map? ?? {});
    componentId = args['componentId']?.toString() ?? '';

    if (rackName.isEmpty || levelName.isEmpty || componentId.isEmpty) {
      log.e('EditComponentsController arguments tidak lengkap: $args');
    }

    _getUserData();

    nameController.text = component['name']?.toString() ?? '';
    descriptionController.text = component['description']?.toString() ?? '';
    stockController.text = (component['stock'] ?? 0).toString();
    networkImage.value = component['imgUrl']?.toString();
    unitName.value = component['unit']?.toString().isNotEmpty == true
        ? component['unit'].toString()
        : 'pcs';

    stock.value = component['stock'] is int
        ? component['stock'] as int
        : int.tryParse(component['stock']?.toString() ?? '0') ?? 0;

    stockController.addListener(() {
      final value = int.tryParse(stockController.text);
      if (value != null) {
        stock.value = value;
      }
    });

    stockFocusNode.addListener(() {
      if (!stockFocusNode.hasFocus && stockController.text.isEmpty) {
        stock.value = 0;
        stockController.text = stock.value.toString();
      }
    });

    setRackAndLevel();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    stockFocusNode.dispose();
    super.onClose();
  }

  void increment() {
    final currentStock = int.tryParse(stockController.text);
    if (currentStock != null) {
      stock.value = currentStock + 1;
      stockController.text = stock.value.toString();
    }
  }

  void decrement() {
    final currentStock = int.tryParse(stockController.text);
    if (currentStock != null && currentStock > 0) {
      stock.value = currentStock - 1;
      stockController.text = stock.value.toString();
    }
  }

  void setRackAndLevel() {
    selectedRack.value = rackName;
    selectedLevel.value = levelName;
  }

  void onChangedRackName(String? value) {
    unitName.value = value ?? '';
  }

  Future<void> onPickImage({required bool isCamera}) async {
    try {
      final image = isCamera
          ? await pickImageFromCamera()
          : await pickImageFromGallery();

      if (image != null) {
        final croppedImageFile = await croppingImage(
          imageFile: image,
          cropStyle: CropStyle.circle,
        );

        if (croppedImageFile != null) {
          isLoadingImage.value = true;

          final croped = XFile(croppedImageFile.path);
          final compressedImage = await compressImageForApi(croped);

          if (compressedImage != null) {
            final tempFile = File(compressedImage.path);
            imageFileController.value = tempFile;
            networkImage.value = null;
          }
        }
      }
    } catch (e) {
      log.e('Error picking image: $e');
      const CustomSnackbar(
        success: false,
        title: 'Error',
        message: 'Gagal mengambil gambar',
      ).showSnackbar();
    } finally {
      isLoadingImage.value = false;
    }
  }

  Future<void> onEditComponentClicked() async {
    try {
      isLoadingAddComponent.value = true;

      String? imageUrl;
      if (imageFileController.value != null) {
        imageUrl = await _uploadImage(imageFileController.value!);
      }

      if (nameController.text.trim().isEmpty) {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon isi nama komponen terlebih dahulu',
        ).showSnackbar();
        return;
      }

      if (stock.value == 0) {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon isi stok terlebih dahulu',
        ).showSnackbar();
        return;
      }

      if (selectedRack.value.isEmpty || selectedLevel.value.isEmpty) {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Pilih rak dan level terlebih dahulu',
        ).showSnackbar();
        return;
      }

      final componentsData = {
        levelName: {
          componentId: {
            'name': nameController.text.trim(),
            'description': descriptionController.text.trim(),
            'stock': stock.value,
            'unit': unitName.value,
            'imgUrl': imageUrl ?? networkImage.value,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        },
      };

      await _updateComponentsToRack(componentsData);
      await _logEditHistoryActivity(
        nameController.text.trim(),
        descriptionController.text.trim(),
        "${stock.value} ${unitName.value}",
      );

      Get.back();
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Komponen Berhasil Diubah',
      ).showSnackbar();
    } catch (e) {
      log.e('Error editing component: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Mengubah Komponen',
      ).showSnackbar();
    } finally {
      isLoadingAddComponent.value = false;
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileName = const Uuid().v4();
      final storageRef = FirebaseStorage.instance.ref().child(
        'components/$fileName',
      );
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log.e('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _updateComponentsToRack(
    Map<String, dynamic> componentsData,
  ) async {
    try {
      final rackRef = FirebaseFirestore.instance
          .collection('components')
          .doc(rackName);

      await rackRef.set(componentsData, SetOptions(merge: true));
    } catch (e) {
      log.e('Error adding/updating component: $e');
      throw Exception('Failed to add/update component');
    }
  }

  Future<void> _getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = userData.data() ?? {};

        if (userData.exists) {
          userName = data['name']?.toString() ?? '';
        } else {
          userName = '';
        }
      }
    } catch (e) {
      debugPrint('Error getting profile data: $e');
    }
  }

  Future<void> _logEditHistoryActivity(
    String name,
    String description,
    String amount,
  ) async {
    try {
      final activityId = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('history')
          .doc('activities')
          .set({
            activityId: {
              'user': userName,
              'itemType': "components",
              'actionType': "edit",
              'xName': name,
              'xDescription': description,
              'xAmount': amount,
              'xLocation': "$rackName, Laci $levelName",
              'timestamp': FieldValue.serverTimestamp(),
            },
          }, SetOptions(merge: true));
    } catch (e) {
      log.e('Failed to log activity: $e');
    }
  }
}
