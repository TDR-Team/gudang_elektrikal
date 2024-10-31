import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController tStockController = TextEditingController();
  FocusNode stockFocusNode = FocusNode();
  FocusNode tStockFocusNode = FocusNode();

  RxBool isLoadingImage = false.obs;
  RxBool isLoadingEditTools = false.obs;
  Rx<File?> imageFileController = RxNullable<File?>().setNull();
  Rx<String?> networkImage = RxNullable<String?>().setNull();

  String? userName;

  // Reactive stock value
  RxInt stock = 0.obs;
  RxInt tStock = 0.obs;

  @override
  void onInit() {
    super.onInit();

    _getUserData();

    nameController.text = tools['name'] ?? '';
    descriptionController.text = tools['description'] ?? '';
    stockController.text = tools['stock'].toString();
    tStockController.text = tools['tStock'].toString();
    networkImage.value = tools['imgUrl'];

    // Initialize stock value
    stock.value = tools['stock'] ?? 0;
    tStock.value = tools['tStock'] ?? 0;

    // Listen to changes in stockController and update the stock value
    stockController.addListener(() {
      int? value = int.tryParse(stockController.text);
      if (value != null) {
        stock.value = value;
      }
    });
    tStockController.addListener(() {
      int? value = int.tryParse(tStockController.text);
      if (value != null) {
        tStock.value = value;
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
    tStockFocusNode.addListener(() {
      if (!tStockFocusNode.hasFocus) {
        if (tStockController.text.isEmpty) {
          tStock.value = 0;
          tStockController.text = tStock.value.toString();
        }
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    tStockController.dispose();
    stockFocusNode.dispose();
    tStockFocusNode.dispose();
    super.onClose();
  }

  void increment() {
    int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null) {
      stock.value = currentStock + 1;
      stockController.text = stock.value.toString();
    }
  }

  void tIncrement() {
    int? currentStock = int.tryParse(tStockController.text);
    if (currentStock != null) {
      tStock.value = currentStock + 1;
      tStockController.text = tStock.value.toString();
    }
  }

  void decrement() {
    int? currentStock = int.tryParse(stockController.text);
    if (currentStock != null && currentStock > 0) {
      stock.value = currentStock - 1;
      stockController.text = stock.value.toString();
    }
  }

  void tDecrement() {
    int? currentStock = int.tryParse(tStockController.text);
    if (currentStock != null && currentStock > 0) {
      tStock.value = currentStock - 1;
      tStockController.text = tStock.value.toString();
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
    try {
      isLoadingEditTools.value = true;

      String? imageUrl;
      if (imageFileController.value != null) {
        imageUrl = await _uploadImage(imageFileController.value!);
      }

      Map<String, dynamic> toolsData = {
        toolsId: {
          'name': nameController.text,
          'description': descriptionController.text,
          'stock': stock.value,
          'tStock': tStock.value,
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

      await _updateToolsInCategory(toolsData);
      await _logHistoryActivity(
        nameController.text,
        descriptionController.text,
        "${tStock.value} buah",
        categoryId,
      );

      Get.back();
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
      DocumentReference categoryRef =
          FirebaseFirestore.instance.collection('tools').doc(categoryId);

      await categoryRef.update(toolsData);
    } catch (e) {
      log.e('Error updating tools in category: $e');
      throw Exception('Failed to update tools in category');
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

  Future<void> _logHistoryActivity(
    String name,
    String description,
    String amount,
    String category,
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
          'itemType': "tools",
          'actionType': "edit",
          'xName': name,
          'xDescription': description,
          'xAmount': amount,
          'xLocation': "Kategori $category",
          'timestamp': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      log.e('Failed to log activity: $e');
    }
  }
}
