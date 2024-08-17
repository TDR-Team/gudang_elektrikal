import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String levelName = Get.arguments['levelName'];
  final String rackName = Get.arguments['rackName'];

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

  void onChangedRackName(String? value) {
    unitName.value = value ?? "";
  }

  void setRackAndLevel() {
    selectedRack.value = rackName;
    selectedLevel.value = levelName;
  }

  // Define the stock as an RxInt to make it reactive
  RxInt stock = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the stockController with the initial stock value
    stockController.text = stock.value.toString();

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
    // Dispose of the controllers and focus nodes
    nameComponent.dispose();
    descriptionComponent.dispose();
    stockController.dispose();
    stockFocusNode.dispose();
    super.onClose();
  }

  Future onPickImage({required bool isCamera}) async {
    try {
      final image =
          isCamera ? await pickImageFromCamera() : await pickImageFromGallery();

      if (image != null) {
        final croppedImageFile =
            await croppingImage(imageFile: image, cropStyle: CropStyle.circle);
        XFile croped = XFile(croppedImageFile?.path ?? "");
        if (croppedImageFile != null) {
          isLoadingImage.value = true;
          XFile? compressedImage = await compressImageForApi(croped);
          var imageTemp = File(image.path);
          if (compressedImage != null) {
            File tempFile = File(compressedImage.path);
            log.i('Size of the file: ${tempFile.path}');
            int beforeSize = await imageTemp.length();
            int newSize = await tempFile.length();
            double beforeSizeMB = beforeSize / (1024 * 1024);
            double newSizeMB = newSize / (1024 * 1024);
            log.i(
                'Size of the file: before ${beforeSizeMB.toStringAsFixed(2)} MB, new ${newSizeMB.toStringAsFixed(2)} MB');
            imageFileController.value = tempFile;
            networkImage.value = null;
          }
        }
      }
    } on PlatformException catch (e) {
      log.e('Failed to pick image: $e');
    }
    isLoadingImage.value = false;
  }

  void increment() {
    // Use the current value from stockController
    int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null) {
      stock.value = currentStock + 1;
      stockController.text = stock.value.toString();
    }
  }

  void decrement() {
    // Use the current value from stockController
    int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null && currentStock > 0) {
      stock.value = currentStock - 1;
      stockController.text = stock.value.toString();
    }
  }

  Future<void> onAddComponentsClicked() async {
    final imageFile = imageFileController.value;
    final name = nameComponent.text;
    final description =
        descriptionComponent.text.isNotEmpty ? descriptionComponent.text : null;
    final stock = this.stock.value;
    final unit = unitName.value;
    isLoadingAddComponent.value = true;

    // Validation checks
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
    if (stock == 0) {
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
      // Upload image to Firebase Storage
      final imagePath =
          'components/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadTask =
          FirebaseStorage.instance.ref().child(imagePath).putFile(imageFile);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        const uuid = Uuid();

        final String componentId = uuid.v4();

        await FirebaseFirestore.instance
            .collection('components')
            .doc(rackName)
            .set({
          levelName: {
            componentId: {
              'name': name,
              'description': description,
              'stock': stock,
              'unit': unit,
              'imgUrl': imageUrl,
              'createdAt': FieldValue.serverTimestamp(),
            }
          }
        }, SetOptions(merge: true));

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
}
