import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/helpers/nullable_rx.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../common/helpers/image_helpers.dart';
import '../../../widgets/custom_snackbar.dart';

class AddComponentsController extends GetxController {
  late final String levelName;
  late final String rackName;

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

    if (rackName.isEmpty || levelName.isEmpty) {
      log.e('AddComponentsController arguments tidak lengkap: $args');
    }

    setRackAndLevel();
    _getUserData();

    stockController.text = stock.value.toString();

    stockController.addListener(() {
      final int? value = int.tryParse(stockController.text);
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
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    stockFocusNode.dispose();
    super.onClose();
  }

  void onChangedRackName(String? value) {
    unitName.value = value ?? '';
  }

  void setRackAndLevel() {
    selectedRack.value = rackName;
    selectedLevel.value = levelName;
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
          final XFile? compressedImage = await compressImageForApi(croped);
          final imageTemp = File(image.path);

          if (compressedImage != null) {
            final tempFile = File(compressedImage.path);

            log.i('Size of the file: ${tempFile.path}');
            final int beforeSize = await imageTemp.length();
            final int newSize = await tempFile.length();
            final double beforeSizeMB = beforeSize / (1024 * 1024);
            final double newSizeMB = newSize / (1024 * 1024);

            log.i(
              'Size of the file: before ${beforeSizeMB.toStringAsFixed(2)} MB, '
              'new ${newSizeMB.toStringAsFixed(2)} MB',
            );

            imageFileController.value = tempFile;
            networkImage.value = null;
          }
        }
      }
    } on PlatformException catch (e) {
      log.e('Failed to pick image: $e');
    } finally {
      isLoadingImage.value = false;
    }
  }

  void increment() {
    final int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null) {
      stock.value = currentStock + 1;
      stockController.text = stock.value.toString();
    }
  }

  void decrement() {
    final int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null && currentStock > 0) {
      stock.value = currentStock - 1;
      stockController.text = stock.value.toString();
    }
  }

  Future<void> onAddComponentsClicked() async {
    final imageFile = imageFileController.value;
    final name = nameController.text.trim();
    final description = descriptionController.text.trim().isNotEmpty
        ? descriptionController.text.trim()
        : null;
    final currentStock = stock.value;
    final unit = unitName.value;

    isLoadingAddComponent.value = true;

    if (imageFile == null) {
      isLoadingAddComponent.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon isi foto terlebih dahulu',
      ).showSnackbar();
      return;
    }

    if (name.isEmpty) {
      isLoadingAddComponent.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon isi nama komponen terlebih dahulu',
      ).showSnackbar();
      return;
    }

    if (currentStock == 0) {
      isLoadingAddComponent.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon isi stok terlebih dahulu',
      ).showSnackbar();
      return;
    }

    if (selectedRack.value.isEmpty || selectedLevel.value.isEmpty) {
      isLoadingAddComponent.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Pilih rak dan level terlebih dahulu',
      ).showSnackbar();
      return;
    }

    try {
      final imagePath =
          'components/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadTask = FirebaseStorage.instance
          .ref()
          .child(imagePath)
          .putFile(imageFile);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        const uuid = Uuid();
        final String componentId = uuid.v4();

        final Map<String, dynamic> componentsData = {
          levelName: {
            componentId: {
              'name': name,
              'description': description,
              'stock': currentStock,
              'unit': unit,
              'imgUrl': imageUrl,
              'createdAt': FieldValue.serverTimestamp(),
            },
          },
        };

        await _addComponentsToRack(componentsData);
        await _logAddComponentsHistoryActivity(
          name,
          description ?? "",
          "$currentStock $unit",
        );

        Get.back();
        const CustomSnackbar(
          success: true,
          title: 'Berhasil',
          message: 'Komponen berhasil ditambahkan',
        ).showSnackbar();
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Gagal mengunggah gambar, coba lagi',
        ).showSnackbar();
      }
    } catch (e) {
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Terjadi kesalahan, mohon coba lagi',
      ).showSnackbar();
      log.e(e);
    } finally {
      isLoadingAddComponent.value = false;
    }
  }

  Future<void> _addComponentsToRack(Map<String, dynamic> componentsData) async {
    try {
      final DocumentReference rackRef = FirebaseFirestore.instance
          .collection('components')
          .doc(rackName);

      await rackRef.set(componentsData, SetOptions(merge: true));
    } catch (e) {
      log.e('Error adding components to rack: $e');
      throw Exception('Failed to add components to rack');
    }
  }

  Future<void> _getUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final Map<String, dynamic> data =
            userData.data() as Map<String, dynamic>? ?? {};

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

  Future<void> _logAddComponentsHistoryActivity(
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
              'actionType': "add",
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
