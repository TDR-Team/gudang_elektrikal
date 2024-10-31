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
  final String levelName = Get.arguments['levelName'];
  final String rackName = Get.arguments['rackName'];
  final Map<String, dynamic> component = Get.arguments['component'];
  final String componentId =
      Get.arguments['componentId']; // Get the component ID

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  FocusNode stockFocusNode = FocusNode();
  RxBool isLoadingImage = false.obs;
  RxBool isLoadingAddComponent = false.obs;
  Rx<File?> imageFileController = RxNullable<File?>().setNull();
  Rx<String?> networkImage = RxNullable<String?>().setNull();
  RxString selectedRack = ''.obs;
  RxString selectedLevel = ''.obs;

  String? userName;

  final unitName = 'Pcs'.obs;
  final listUnit = ['Meter', 'Pcs', 'Dus', 'Box', 'Pack', 'Roll'];

  // Reactive stock value
  RxInt stock = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserData();

    nameController.text = component['name'] ?? '';
    descriptionController.text = component['description'] ?? '';
    stockController.text = component['stock'].toString();
    networkImage.value = component['imgUrl'];
    unitName.value = component['unit'] ?? 'Pcs';

    // Initialize stock value
    stock.value = component['stock'] ?? 0;

    // Listen to changes in stockController and update the stock value
    stockController.addListener(() {
      int? value = int.tryParse(stockController.text);
      if (value != null) {
        stock.value = value;
      }
    });

    // Add a focus listener to the stock focus node
    stockFocusNode.addListener(() {
      if (!stockFocusNode.hasFocus) {
        if (stockController.text.isEmpty) {
          stock.value = 0;
          stockController.text = stock.value.toString();
        }
      }
    });

    // Set rack and level upon initialization
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
    int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null) {
      stock.value = currentStock + 1;
      stockController.text = stock.value.toString();
    }
  }

  void decrement() {
    int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null && currentStock > 0) {
      stock.value = currentStock - 1;
      stockController.text = stock.value.toString();
    }
  }

  // Set rack and level
  void setRackAndLevel() {
    selectedRack.value = rackName;
    selectedLevel.value = levelName;
  }

  // Change rack/unit name
  void onChangedRackName(String? value) {
    unitName.value = value ?? '';
  }

  // Image picking and uploading
  Future onPickImage({required bool isCamera}) async {
    try {
      final image =
          isCamera ? await pickImageFromCamera() : await pickImageFromGallery();

      if (image != null) {
        final croppedImageFile =
            await croppingImage(imageFile: image, cropStyle: CropStyle.circle);
        if (croppedImageFile != null) {
          isLoadingImage.value = true;

          // Compress the image for API usage
          XFile croped = XFile(croppedImageFile.path);
          XFile? compressedImage = await compressImageForApi(croped);

          if (compressedImage != null) {
            File tempFile = File(compressedImage.path);
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

  Future onEditComponentClicked() async {
    try {
      isLoadingAddComponent.value = true;

      // Upload image to Firebase Storage if an image is picked
      String? imageUrl;
      if (imageFileController.value != null) {
        imageUrl = await _uploadImage(imageFileController.value!);
      }

      // Create component data
      Map<String, dynamic> componentsData = {
        levelName: {
          componentId: {
            'name': nameController.text,
            'description': descriptionController.text,
            'stock': stock.value,
            'unit': unitName.value,
            'imgUrl': imageUrl ?? networkImage.value,
            'updatedAt': FieldValue.serverTimestamp(),
          }
        }
      };

      // Validation checks
      if (nameController.text.isEmpty) {
        isLoadingAddComponent.value = false;
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon isi nama komponen terlebih dahulu',
        ).showSnackbar();
        return;
      }
      if (stock.value == 0) {
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

      await _updateComponentsToRack(componentsData);
      await _logEditHistoryActivity(
        nameController.text,
        descriptionController.text,
        "${unitName.value} ${stock.value}",
      );

      Get.back();
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Komponen Berhasil Diubah',
      ).showSnackbar();
    } catch (e) {
      log.e('Error adding component: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Mengubah Komponen',
      ).showSnackbar();
    } finally {
      isLoadingAddComponent.value = false;
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = const Uuid().v4();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('components/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log.e('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _updateComponentsToRack(
      Map<String, dynamic> componentsData) async {
    try {
      // Reference to the specific rack document
      DocumentReference rackRef =
          FirebaseFirestore.instance.collection('components').doc(rackName);

      await rackRef.set(componentsData, SetOptions(merge: true));
    } catch (e) {
      log.e('Error adding/updating component: $e');
      throw Exception('Failed to add/update component');
    }
  }

  Future<void> _getUserData() async {
    try {
      update();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        update();

        // Convert DocumentSnapshot to Map<String, dynamic>
        Map<String, dynamic> data =
            userData.data() as Map<String, dynamic>? ?? {};

        // Check if the document exists
        if (userData.exists) {
          userName = data['name'] ?? '';
          update();
        } else {
          // Handle case where document does not exist
          userName = '';
          update();
        }
      }
      update();
    } catch (e) {
      debugPrint('Error getting profile data: $e');
    } finally {
      update();
    }
  }

  Future<void> _logEditHistoryActivity(
    String name,
    String description,
    String amount,
  ) async {
    try {
      final activityId =
          const Uuid().v4(); // Generate a unique ID for the activity
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
        }
      }, SetOptions(merge: true));
    } catch (e) {
      log.e('Failed to log activity: $e');
    }
  }
}
