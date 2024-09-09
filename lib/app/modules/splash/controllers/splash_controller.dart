import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    User? user = FirebaseAuth.instance.currentUser;

    Timer(
      const Duration(seconds: 3),
      () async {
        if (user != null) {
          Get.offAllNamed('/dashboard');
        } else {
          Get.offAllNamed('/login');
        }
      },
    );
  }
}
