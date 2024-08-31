import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  TextEditingController nameComponent = TextEditingController();
  TextEditingController descriptionComponent = TextEditingController();
  TextEditingController stockController = TextEditingController();
  FocusNode stockFocusNode = FocusNode();
  RxBool isLoadingImage = false.obs;
  RxBool isLoadingAddComponent = false.obs;
  Rx<File?> imageFileController = RxNullable<File?>().setNull();
  Rx<String?> networkImage = RxNullable<String?>().setNull();
  RxString selectedRack = ''.obs;
  RxString selectedLevel = ''.obs;

  final unitName = 'Pcs'.obs;
  final listUnit = ['Meter', 'Pcs', 'Dus', 'Box', 'Pack'];

  // Reactive stock value
  RxInt stock = 0.obs;

  @override
  void onInit() {
    super.onInit();

    nameComponent.text = component['name'] ?? '';
    descriptionComponent.text = component['description'] ?? '';
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
    nameComponent.dispose();
    descriptionComponent.dispose();
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
      Map<String, dynamic> componentData = {
        'id': componentId,
        'name': nameComponent.text,
        'description': descriptionComponent.text,
        'stock': stock.value,
        'unit': unitName.value,
        'imgUrl': imageUrl ??
            networkImage.value, // Include existing imageUrl if no new image
      };

      // Validation checks
      if (nameComponent.text.isEmpty) {
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

      await _addOrUpdateComponent(componentData);
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

  Future<void> _addOrUpdateComponent(Map<String, dynamic> componentData) async {
    try {
      // Reference to the specific rack document
      DocumentReference rackDocRef =
          FirebaseFirestore.instance.collection('components').doc(rackName);

      // The data to update or add
      Map<String, dynamic> levelData = {
        levelName: {componentId: componentData}
      };

      // Update or add component data within the document
      await rackDocRef.set(levelData, SetOptions(merge: true));
    } catch (e) {
      log.e('Error adding/updating component: $e');
      throw Exception('Failed to add/update component');
    }
  }
}
