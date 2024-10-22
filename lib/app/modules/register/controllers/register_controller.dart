import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  late User? user;
  bool isLoading = false;
  bool isPasswordHide = true;
  bool isConfirmPasswordHide = true;
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void onPressedIconPassword({required bool isPassword}) {
    if (isPassword) {
      isPasswordHide = !isPasswordHide;
    } else {
      isConfirmPasswordHide = !isConfirmPasswordHide;
    }
    update();
  }

  Future<void> register() async {
    try {
      isLoading = true;
      update();

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text,
        'email': emailController.text.trim(),
      });

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Gagal', 'Registrasi tidak berhasil, Mohon coba lagi.');
    } finally {
      isLoading = false;
      update();
    }
  }
}
