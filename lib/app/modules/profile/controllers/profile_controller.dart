import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/modules/login/views/login_view.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  late User user;

  String? name;
  String? email;
  int? phone;
  String? profileImageUrl; // Add this line to store profile image URL

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
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        update();

        // Convert DocumentSnapshot to Map<String, dynamic>
        Map<String, dynamic> data =
            userData.data() as Map<String, dynamic>? ?? {};

        // Check if the document exists
        if (userData.exists) {
          name = data['name'] ?? '';
          email = user.email ?? '';
          update();

          // Check for phone number
          if (data.containsKey('phone')) {
            phone = data['phone'];
          } else {
            phone = null; // Handle case where 'phone' is not provided
          }
          update();

          // Check for profile image URL
          if (data.containsKey('photoUrl')) {
            profileImageUrl = data['photoUrl'];
          } else {
            profileImageUrl =
                null; // Handle case where 'photoUrl' is not provided
          }
          update();
        } else {
          // Handle case where document does not exist
          name = '';
          email = '';
          phone = null;
          profileImageUrl = null;
          update();
        }
      }
      update();
    } catch (e) {
      print('Error getting profile data: $e');
      // Handle error appropriately, e.g., show snackbar or log error
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(const LoginView()); // Navigate to LoginView after sign out
    } catch (e) {
      // Handle sign-out errors
      print('Error signing out: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading = true;
      update();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Delete user from Firebase Authentication
        await user.delete();

        // Sign out the user

        Get.offAll(const LoginView());
      }
    } catch (e) {
      print('Error deleting account: $e');
      Get.snackbar('Error', 'Failed to delete account');
    } finally {
      isLoading = false;
      update();
    }
  }
}
