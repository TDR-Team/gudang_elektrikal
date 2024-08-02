import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  late User? user; // Menggunakan User? langsung dari FirebaseAuth
  bool isLoading = false; // State untuk loading
  bool isPasswordHide = true;
  bool formValid = false;
  bool correctEmail = false;
  bool correctPassword = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user = FirebaseAuth.instance.currentUser;
  }

  void onPressedIconPassword() {
    isPasswordHide = !isPasswordHide;
    update();
  }

  Future<void> register() async {
    try {
      isLoading = true; // Set isLoading menjadi true saat memulai proses
      update(); // Update state jika ada perubahan

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Add user information to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text,
        'email': emailController.text.trim(),
      });

      isLoading = false; // Set isLoading menjadi false setelah selesai
      update(); // Update state jika ada perubahan

      // Navigate to login screen after successful registration
      Get.offAllNamed('/login'); // Change '/login' to your desired route
    } catch (e) {
      isLoading = false; // Set isLoading menjadi false jika terjadi error
      print('Error: $e');
      // Handle registration errors
      // Optionally, show error message to the user
      Get.snackbar('Error', 'Registration failed. Please try again.');
    } finally {
      isLoading = false;
      update();
    }
  }
}
