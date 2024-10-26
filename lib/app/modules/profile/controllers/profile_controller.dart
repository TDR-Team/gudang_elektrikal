import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  late User user;

  String? name;
  String? email;
  int? phone;
  String? profileImageUrl;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserData());
    user = FirebaseAuth.instance.currentUser!;
    getUserData();
  }

  @override
  void onReady() {
    super.onReady();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      isLoading = true;
      update();

      User? user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      Map<String, dynamic> data =
          userData.data() as Map<String, dynamic>? ?? {};

      if (userData.exists) {
        name = data['name'] ?? '';
        email = user.email ?? '';

        if (data.containsKey('photoUrl')) {
          profileImageUrl = data['photoUrl'];
        } else {
          profileImageUrl = null;
        }
        update();
      } else {
        name = '';
        email = '';
        phone = null;
        profileImageUrl = null;
        update();
      }
    } catch (e, st) {
      log.e('Error getting profile data: $e, location: $st');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed<void>(Routes.LOGIN);
    } catch (e, st) {
      log.e('Error signing out: $e, location $st');
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading = true;
      update();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        await user.delete();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e, st) {
      log.e('Error deleting account: $e, location: $st');
      Get.snackbar('Error', 'Gagal menghapus Akun');
    } finally {
      isLoading = false;
      update();
    }
  }
}
