import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    if (isLoading) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Email dan password tidak boleh kosong.',
      ).showSnackbar();
      return;
    }

    try {
      isLoading = true;
      update();

      log.i('Attempt sign in with email: $email');

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      user = userCredential.user;

      if (user != null && !user!.emailVerified) {
        await FirebaseAuth.instance.signOut();

        const CustomSnackbar(
          success: false,
          title: 'Email belum terverifikasi',
          message: 'Silakan verifikasi email Anda terlebih dahulu.',
        ).showSnackbar();
        return;
      }

      log.i('Sign in success. uid: ${user?.uid}, email: ${user?.email}');

      Get.offAllNamed(Routes.DASHBOARD);

      const CustomSnackbar(
        success: true,
        title: 'Selamat datang',
        message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
        duration: 5,
      ).showSnackbar();
    } on FirebaseAuthException catch (e, st) {
      errorCode = e.code;
      log.e(
        'FirebaseAuthException: code=${e.code}, message=${e.message}, email=$email, location: $st',
      );

      final errorMessage = ErrorMessageFirebaseHelper().getMessageFromErrorCode(
        e.code,
      );

      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: errorMessage,
      ).showSnackbar();
    } catch (e, st) {
      log.e('Unexpected error: $e, location: $st');

      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Terjadi kesalahan. Mohon coba lagi.',
      ).showSnackbar();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signInWithGoogle() async {
    if (isLoading) return;

    try {
      isLoading = true;
      update();

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      await googleSignIn.signOut();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google ID token tidak ditemukan.');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
              'name': user!.displayName,
              'email': user!.email,
              'photoUrl': user!.photoURL,
              'lastLoginAt': FieldValue.serverTimestamp(),
              'provider': 'google',
            }, SetOptions(merge: true));
      }

      if (userCredential.user != null) {
        Get.offAllNamed(Routes.DASHBOARD);

        const CustomSnackbar(
          success: true,
          title: 'Selamat datang',
          message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
          duration: 5,
        ).showSnackbar();
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Mohon coba masuk kembali.',
        ).showSnackbar();
      }
    } on FirebaseAuthException catch (e, st) {
      log.e(
        'Google sign-in FirebaseAuthException: ${e.code}, message: ${e.message}, location: $st',
      );

      final String errorMessage = ErrorMessageFirebaseHelper()
          .getMessageFromErrorCode(e.code);

      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: errorMessage,
      ).showSnackbar();
    } on GoogleSignInException catch (e, st) {
      log.e(
        'GoogleSignInException: code=${e.code}, description=${e.description}, location: $st',
      );

      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Login Google dibatalkan atau gagal diproses.',
      ).showSnackbar();
    } catch (e, st) {
      log.e('Google sign-in error: $e, location: $st');

      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Mohon coba masuk kembali.',
      ).showSnackbar();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signOutGoogle() async {
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }

  void onPressedIconPassword() {
    isPasswordHide = !isPasswordHide;
    update();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:gudang_elektrikal/app/common/helpers/error_message_firebase_helper.dart';
// import 'package:gudang_elektrikal/app/routes/app_pages.dart';
// import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

// import '../../../utils/logging.dart';

// class LoginController extends GetxController {
//   User? user;
//   bool isLoading = false;
//   bool isPasswordHide = true;
//   bool formValid = false;
//   bool correctEmail = false;
//   bool correctPassword = false;

//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   String? errorCode;

//   @override
//   void onInit() {
//     super.onInit();
//     user = FirebaseAuth.instance.currentUser;
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   Future<void> signIn() async {
//     try {
//       isLoading = true;
//       update();

//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text,
//       );
//       user = userCredential.user;

//       const CustomSnackbar(
//         success: true,
//         title: 'Selamat datang',
//         message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
//         duration: 5,
//       ).showSnackbar();
//       Get.offAllNamed(Routes.DASHBOARD);
//     } on FirebaseAuthException catch (e, st) {
//       errorCode = e.code;
//       log.e('Error : $errorCode, location: $st');
//       String errorMessage =
//           ErrorMessageFirebaseHelper().getMessageFromErrorCode(errorCode!);

//       CustomSnackbar(
//         success: false,
//         title: 'Gagal',
//         message: errorMessage,
//       ).showSnackbar();
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

//   Future<void> signInWithGoogle() async {
//     try {
//       await GoogleSignIn().signOut();
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) {
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(
//         credential,
//       );

//       user = FirebaseAuth.instance.currentUser;

//       await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
//         'name': user!.displayName,
//         'email': user!.email,
//       });

//       if (userCredential.user != null) {
//         const CustomSnackbar(
//           success: true,
//           title: 'Selamat datang',
//           message: 'Mari mengatur komponen dan alat di Gudang Elektrikal!',
//           duration: 5,
//         ).showSnackbar();
//         Get.offAllNamed(Routes.DASHBOARD);
//       } else {
//         const CustomSnackbar(
//           success: false,
//           title: 'Gagal',
//           message: 'Mohon coba masuk kembali',
//         ).showSnackbar();
//       }
//       update();
//     } catch (e) {
//       log.e('Error $e');
//       const CustomSnackbar(
//         success: false,
//         title: 'Gagal',
//         message: 'Mohon coba masuk kembali',
//       ).showSnackbar();
//     }
//   }

//   Future<void> signOutGoogle() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   void onPressedIconPassword() {
//     isPasswordHide = !isPasswordHide;
//     update();
//   }
// }
