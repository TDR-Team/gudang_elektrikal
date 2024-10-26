import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gudang_elektrikal/app/common/helpers/error_message_firebase_helper.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

import '../../../utils/logging.dart';

class LoginController extends GetxController {
  User? user;
  bool isLoading = false;
  bool isPasswordHide = true;
  bool formValid = false;
  bool correctEmail = false;
  bool correctPassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorCode;

  @override
  void onInit() {
    super.onInit();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    try {
      isLoading = true;
      update();

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      user = userCredential.user;

      const CustomSnackbar(
        success: true,
        title: 'Selamat datang',
        message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
        duration: 5,
      ).showSnackbar();
      Get.offAllNamed(Routes.DASHBOARD);
    } on FirebaseAuthException catch (e, st) {
      errorCode = e.code;
      log.e('Error : $errorCode, location: $st');
      String errorMessage =
          ErrorMessageFirebaseHelper().getMessageFromErrorCode(errorCode!);

      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: errorMessage,
      ).showSnackbar();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': user!.displayName,
        'email': user!.email,
      });

      if (userCredential.user != null) {
        const CustomSnackbar(
          success: true,
          title: 'Selamat datang',
          message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
          duration: 5,
        ).showSnackbar();
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon coba masuk kembali',
        ).showSnackbar();
      }
      update();
    } catch (e) {
      log.e('Error $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon coba masuk kembali',
      ).showSnackbar();
    }
  }

  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
  }

  void onPressedIconPassword() {
    isPasswordHide = !isPasswordHide;
    update();
  }
}
