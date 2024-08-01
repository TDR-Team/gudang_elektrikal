import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/helpers/nullable_rx.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/helpers/image_helpers.dart';

class AddComponentsController extends GetxController {
  TextEditingController nameComponent = TextEditingController();
  TextEditingController descriptionComponent = TextEditingController();
  TextEditingController stockController = TextEditingController();
  FocusNode stockFocusNode = FocusNode();
  RxBool isLoadingImageProfile = false.obs;
  Rx<File?> imageProfileFileController = RxNullable<File?>().setNull();
  Rx<String?> networkImageProfile = RxNullable<String?>().setNull();

  final unitName = 'Pcs'.obs;
  final listUnit = ['Meter', 'Pcs', 'Dus', 'Box', 'Pack'];

  void onChangedRackName(String? value) {
    unitName.value = value ?? "";
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

  Future onPickImageProfile({required bool isCamera}) async {
    try {
      final image =
          isCamera ? await pickImageFromCamera() : await pickImageFromGallery();

      if (image != null) {
        final croppedImageFile =
            await croppingImage(imageFile: image, cropStyle: CropStyle.circle);
        XFile croped = XFile(croppedImageFile?.path ?? "");
        if (croppedImageFile != null) {
          isLoadingImageProfile.value = true;
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
            imageProfileFileController.value = tempFile;
            networkImageProfile.value = null;
          }
        }
      }
    } on PlatformException catch (e) {
      log.e('Failed to pick image: $e');
    }
    isLoadingImageProfile.value = false;
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
}
