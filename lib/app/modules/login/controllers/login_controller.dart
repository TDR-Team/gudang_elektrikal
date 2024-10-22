import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gudang_elektrikal/app/common/helpers/error_message_firebase_helper.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';

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
      Get.offAllNamed(Routes.DASHBOARD);
    } on FirebaseAuthException catch (e, st) {
      errorCode = e.code;
      log.e('Error : $errorCode, location: $st');
      String errorMessage =
          ErrorMessageFirebaseHelper().getMessageFromErrorCode(errorCode!);
      Get.snackbar(
        'Terjadi Kesalahan',
        errorMessage,
      );
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
        Get.snackbar('Berhasil', 'Berhasil masuk dengan Google');
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar('Gagal', 'Mohon coba lagi.');
      }
      update();
    } catch (e) {
      log.e('Error $e');
      Get.snackbar('Error', 'Error Sign In with Google!');
    }
  }

  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    Get.snackbar('Keluar dari Akun', 'Berhasil keluar dari akun Google');
  }

  void onPressedIconPassword() {
    isPasswordHide = !isPasswordHide;
    update();
  }
}
