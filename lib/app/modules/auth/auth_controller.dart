import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startAuthCheck();
  }

  void startAuthCheck() {
    User? user = FirebaseAuth.instance.currentUser;

    Timer(
      const Duration(seconds: 2),
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
