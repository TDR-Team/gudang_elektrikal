import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool isLoading = false;
  bool isLoadingSaveEdit = false;
  String? profileImageUrl;

  File? get image => _image;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      isLoading = true;
      update();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

          nameController.text = data['name'] ?? '';
          emailController.text = user.email ?? '';

          // Check for phone number and handle it appropriately
          if (data.containsKey('phone') && data['phone'] != null) {
            phoneController.text = '0${data['phone']}';
          } else {
            phoneController.text = '';
          }

          profileImageUrl = data['photoUrl'];
        } else {
          nameController.text = '';
          emailController.text = '';
          phoneController.text = '';
          profileImageUrl = null;
        }
      }
    } catch (e) {
      print('Error getting profile data: $e');
      Get.snackbar('Error', 'Failed to fetch user data');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> pickImage() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  _image = File(pickedFile.path);
                  update();
                }
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  _image = File(pickedFile.path);
                  update();
                }
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveUserData() async {
    try {
      isLoadingSaveEdit = true;
      update();

      User? user = FirebaseAuth.instance.currentUser;

      // Prepare data to update in Firestore
      Map<String, dynamic> userData = {
        'name': nameController.text.isNotEmpty ? nameController.text : null,
        'phone': phoneController.text.isNotEmpty
            ? int.parse(phoneController.text)
            : '',
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update(userData);

      // Get.offAll(const BottomNavBarView(index: 1))!
      //     .then((value) => getUserData());
      Get.back();
      Get.snackbar('Berhasil', 'Berhasil mengubah profil');

      update();
      // }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save user data');
      print('errrrorr $e');
    } finally {
      isLoadingSaveEdit = false;
      update();
    }
  }
}
