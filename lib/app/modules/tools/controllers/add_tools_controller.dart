import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/helpers/image_helpers.dart';
import 'package:gudang_elektrikal/app/common/helpers/nullable_rx.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddToolsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  FocusNode stockFocusNode = FocusNode();

  RxBool isLoadingImage = false.obs;
  RxBool isLoadingAddTools = false.obs;
  Rx<File?> imageFileController = RxNullable<File?>().setNull();
  Rx<String?> networkImage = RxNullable<String?>().setNull();
  RxInt stock = 0.obs;

  String? userName;

  final categoryName = ''.obs;
  RxList<String> listCategory = <String>[].obs;

  void onChangedCategory(String? value) {
    categoryName.value = value ?? "";
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tools').get();

      listCategory.value = snapshot.docs.map((doc) => doc.id).toList();

      if (listCategory.isNotEmpty) {
        categoryName.value = listCategory.first;
      }
    } catch (e) {
      log.e('Error fetching categories: $e');
      const CustomSnackbar(
        success: false,
        title: 'Error',
        message: 'Gagal mengambil kategori',
      ).showSnackbar();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getUserData();
    fetchCategories();
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
    nameController.dispose();
    descriptionController.dispose();
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

  Future<void> onAddToolsClicked() async {
    final imageFile = imageFileController.value;
    final name = nameController.text;
    final description = descriptionController.text.isNotEmpty
        ? descriptionController.text
        : null;
    final stock = this.stock.value;
    isLoadingAddTools.value = true;

    // Validation checks
    if (imageFile == null) {
      isLoadingAddTools.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon isi foto terlebih dahulu',
      ).showSnackbar();
      return;
    }
    if (name.isEmpty) {
      isLoadingAddTools.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon isi nama komponen terlebih dahulu',
      ).showSnackbar();
      return;
    }
    if (stock == 0) {
      isLoadingAddTools.value = false;
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon isi stok terlebih dahulu',
      ).showSnackbar();
      return;
    }

    try {
      final imagePath = 'tools/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadTask =
          FirebaseStorage.instance.ref().child(imagePath).putFile(imageFile);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        const uuid = Uuid();
        final String toolsId = uuid.v4();

        Map<String, dynamic> toolsData = {
          toolsId: {
            'name': name,
            'description': description,
            'stock': stock,
            'tStock': stock,
            'imgUrl': imageUrl,
            'createdAt': FieldValue.serverTimestamp(),
          }
        };

        // Add tools data to the specified category
        await _addToolsInCategory(toolsData);
        await _logAddToolsHistoryActivity(
          name,
          description ?? "",
          "$stock buah",
          categoryName.value,
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
      isLoadingAddTools.value = false;
    }
  }

  Future<void> _addToolsInCategory(Map<String, dynamic> toolsData) async {
    try {
      DocumentReference categoryRef = FirebaseFirestore.instance
          .collection('tools')
          .doc(categoryName.value);

      await categoryRef.set(toolsData, SetOptions(merge: true));
    } catch (e) {
      log.e('Error adding tools in category: $e');
      throw Exception('Failed to add tools in category');
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

  Future<void> _logAddToolsHistoryActivity(
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
          'actionType': "add",
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
