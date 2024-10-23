import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  User? user;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e, st) {
      log.e('Error: $e, location: $st');
      CustomSnackbar(success: false, title: 'Gagal', message: e.toString());
    }
  }

  Future<void> sendPasswordResetLink({required String email}) async {
    isLoading = true;
    update();
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      CustomSnackbar(success: false, title: 'Gagal', message: e.toString());
      throw Exception(err.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
