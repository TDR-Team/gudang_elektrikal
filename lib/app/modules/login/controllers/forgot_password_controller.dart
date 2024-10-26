import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  User? user;
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendPasswordResetLink() async {
    isLoading = true;
    update();
    try {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        throw Exception("Email tidak boleh kosong");
      }

      // Cek keberadaan email di Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Email belum terdaftar.',
        ).showSnackbar();
        return;
      }
      await _auth.setSettings(appVerificationDisabledForTesting: true);
      await _auth.setLanguageCode('id');
      await _auth.sendPasswordResetEmail(
        email: email,
      );

      const CustomSnackbar(
        success: true,
        title: 'Email berhasil di kirim',
        message: 'Mohon cek email anda',
      ).showSnackbar();
    } on FirebaseAuthException catch (err) {
      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: err.message.toString(),
      ).showSnackbar();
    } catch (err) {
      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: err.toString(),
      ).showSnackbar();
    } finally {
      isLoading = false;
      update();
    }
  }
}
