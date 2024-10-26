import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/common/helpers/error_message_firebase_helper.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

class RegisterController extends GetxController {
  late User? user;
  bool isLoading = false;
  bool isPasswordHide = true;
  bool isConfirmPasswordHide = true;
  bool formValid = false;
  bool correctEmail = false;
  bool correctPassword = false;
  String? errorCode;

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

      await userCredential.user!.sendEmailVerification();
      debugPrint(
          'Email verification link sent to ${userCredential.user!.email}');

      const CustomSnackbar(
        success: true,
        title: 'Mohon cek email anda',
        message:
            'Link verifikasi telah dikirim ke email Anda. Silakan verifikasi terlebih dahulu.',
      ).showSnackbar();

      checkEmailVerification(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
      String errorMessage =
          ErrorMessageFirebaseHelper().getMessageFromErrorCode(errorCode!);

      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: errorMessage,
      ).showSnackbar();
    } catch (e) {
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Registrasi tidak berhasil, mohon coba lagi.',
      ).showSnackbar();
    } finally {
      isLoading = false;
      update();
    }
  }

  void checkEmailVerification(User user) async {
    const int maxAttempts = 10;
    int attempts = 0;

    isLoading = true;
    update();

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 3));
      await user.reload();
      user = FirebaseAuth.instance.currentUser!;

      if (user.emailVerified) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text.trim(),
          'emailVerified': true,
        });

        const CustomSnackbar(
          success: true,
          title: 'Selamat datang',
          message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
          duration: 5,
        ).showSnackbar();
        Get.offAllNamed(Routes.DASHBOARD);
        return;
      }
      attempts++;
    }
    const CustomSnackbar(
      success: false,
      title: 'Verifikasi Gagal',
      message:
          'Email Anda belum terverifikasi. Silakan cek email Anda atau coba lagi.',
    ).showSnackbar();
    isLoading = false;
    update();
  }
}
