import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gudang_elektrikal/app/utils/validation_helpers.dart';

class LoginController extends GetxController {
  User? user; // Firebase User object
  bool isLoading = false;
  bool isPasswordHide = true;
  bool formValid = false;
  bool correctEmail = false;
  bool correctPassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorCode; // Variable to hold Firebase error code

  @override
  void onInit() {
    super.onInit();
    // Check if user is already signed in
    user = FirebaseAuth.instance.currentUser;
  }

  LoginController() {
    _addListeners();
    update();
  }

  void _addListeners() {
    _addControllerListener(
      emailController,
      ValidationHelpers.validateEmail,
      correctEmail,
    );
    _addControllerListener(
      passwordController,
      (text) => ValidationHelpers.validatePassword(
        value: text,
        isRegister: false,
      ),
      correctPassword,
    );
  }

  void _addControllerListener(
    TextEditingController controller,
    String? Function(String) validator,
    bool correct,
  ) {
    controller.addListener(
      () {
        String? textValidate = validator(controller.text);
        correct = textValidate == null;
        formValid = _isFormValid();
        print('formValid $formValid');
        update();
      },
    );
  }

  bool _isFormValid() {
    return correctEmail && correctPassword;
  }

  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Server error, please try again later.";
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "channel-error":
        return "Belum Mengisi";
      case "invalid-email":
        return "Email anda invalid";
      case "invalid-credential":
        return "Email atau Password anda salah";
      default:
        return "Gagal Masuk. Mohon coba lagi";
    }
  }

  Future<void> onLoginClicked() async {
    try {
      isLoading = true;
      update();

      // Perform Firebase sign in
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Update local user object
      user = userCredential.user;

      // Navigate to home or profile screen
      Get.offAllNamed('/dashboard'); // Change '/home' to your desired route
    } on FirebaseAuthException catch (e) {
      errorCode = e.code; // Capture Firebase error code
      print('errorrr : $errorCode');
      String errorMessage = getMessageFromErrorCode(errorCode!);
      Get.snackbar(
        'Terjadi Kesalahan',
        errorMessage,
      );
    } finally {
      isLoading = false;
      update(); // Set isLoading to false when login process ends (success or error)
    }
  }

  bool isValid() {
    return emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty;
  }

  void onPressedIconPassword() {
    isPasswordHide = !isPasswordHide;
    update();
  }
}
