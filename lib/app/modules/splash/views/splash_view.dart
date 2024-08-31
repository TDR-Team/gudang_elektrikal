import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Delay splash screen for 3 seconds
    Timer(
      const Duration(seconds: 3),
      () => _navigateToNextScreen(), // Navigate after splash
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_pln.png'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'PUSHARLIS', // Ganti dengan judul aplikasi Anda
              style: boldText24.copyWith(
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Pengguna sudah login, navigasi ke Dashboard
      Get.offAllNamed('/dashboard');
    } else {
      // Pengguna belum login, navigasi ke LoginView
      Get.offAllNamed('/login');
    }
  }
}
