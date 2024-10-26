import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  User? user;
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  int sendAttempts = 0;
  int timerSeconds = 0;
  Timer? _timer;

  bool get isSendButtonDisabled => isLoading || timerSeconds > 0;

  @override
  void onClose() {
    emailController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timerSeconds = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        timer.cancel();
        update();
      } else {
        timerSeconds--;
        update();
      }
    });
  }

  Future<void> sendPasswordResetLink() async {
    if (sendAttempts >= 3) {
      _showEmailChangeDialog();
      return;
    }

    isLoading = true;
    update();

    try {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        throw Exception("Email tidak boleh kosong");
      }

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

      await _auth.setLanguageCode('id');
      await _auth.sendPasswordResetEmail(email: email);

      sendAttempts++;
      startTimer();

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

  void _showEmailChangeDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Terlalu Banyak Permintaan',
            style: semiBoldText16,
          ),
          content: Text(
            'Anda telah mencapai batas kirim email.\nUbah email?',
            style: regularText12,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                emailController.clear();
                sendAttempts = 0;
                update();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: kColorScheme.error,
                  ),
                ),
                child: Text(
                  'Ya',
                  style: semiBoldText12.copyWith(
                    color: kColorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
