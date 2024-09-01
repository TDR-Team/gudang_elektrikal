import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/helpers/image_helpers.dart';
import 'package:gudang_elektrikal/app/common/helpers/nullable_rx.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditToolsController extends GetxController {
  final Map<String, dynamic> tools = Get.arguments['tools'];
  final String categoryId = Get.arguments['categoryId']; // Get the category ID
  final String toolsId = Get.arguments['toolsId']; // Get the tools ID

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  FocusNode stockFocusNode = FocusNode();

  RxBool isLoadingImage = false.obs;
  RxBool isLoadingEditTools = false.obs;
  Rx<File?> imageFileController = RxNullable<File?>().setNull();
  Rx<String?> networkImage = RxNullable<String?>().setNull();

  // Reactive stock value
  RxInt stock = 0.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.text = tools['name'] ?? '';
    descriptionController.text = tools['description'] ?? '';
    stockController.text = tools['tStock'].toString();
    networkImage.value = tools['imgUrl'];

    // Initialize stock value
    stock.value = tools['stock'] ?? 0;

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

  Future onEditToolsClicked() async {
    int tempStock = tools['tStock'] - tools['stock'];

    try {
      isLoadingEditTools.value = true;

      // Upload image to Firebase Storage if an image is picked
      String? imageUrl;
      if (imageFileController.value != null) {
        imageUrl = await _uploadImage(imageFileController.value!);
      }

      // Create tools data
      Map<String, dynamic> toolsData = {
        toolsId: {
          'name': nameController.text,
          'description': descriptionController.text,
          'stock': stock.value - tempStock,
          'tStock': stock.value,
          'imgUrl': imageUrl ?? networkImage.value,
          'updatedAt': FieldValue.serverTimestamp(),
        }
      };

      // Validation checks
      if (nameController.text.isEmpty) {
        isLoadingEditTools.value = false;
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon isi nama komponen terlebih dahulu',
        ).showSnackbar();
        return;
      }
      if (stock.value == 0) {
        isLoadingEditTools.value = false;
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon isi stok terlebih dahulu',
        ).showSnackbar();
        return;
      }

      // Update the tools in Firestore within the specific category
      await _updateToolsInCategory(toolsData);
      Get.back(); // Go back to the previous screen
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Komponen Berhasil Diubah',
      ).showSnackbar();
    } catch (e) {
      log.e('Error updating component: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Mengubah Komponen',
      ).showSnackbar();
    } finally {
      isLoadingEditTools.value = false;
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = const Uuid().v4();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('tools/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log.e('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _updateToolsInCategory(Map<String, dynamic> toolsData) async {
    try {
      // Mengambil dokumen kategori
      DocumentReference categoryRef =
          FirebaseFirestore.instance.collection('tools').doc(categoryId);

      // Update tools yang ada dalam map pada dokumen kategori
      await categoryRef.update(toolsData);
    } catch (e) {
      log.e('Error updating tools in category: $e');
      throw Exception('Failed to update tools in category');
    }
  }
}
