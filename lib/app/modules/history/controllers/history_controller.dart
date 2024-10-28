import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';
import 'package:uuid/uuid.dart';

class HistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isLoadingBorrowed = false.obs;
  final isLoadingActivities = false.obs;

  final activitiesList = [].obs;
  final borrowedList = [].obs;

  final selectedIndex = 0.obs;
  late TabController tabController;

  String? userName;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabChange);
    fetchActivities();
    fetchBorrowed();
    _getUserData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    super.onClose();
  }

  void _handleTabChange() {}

  Future<void> fetchActivities() async {
    isLoadingActivities.value = true;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('history')
          .doc('activities')
          .get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        activitiesList.clear();

        final sortedActivities = data.entries.map((entry) {
          return {
            'id': entry.key,
            'user': entry.value['user'],
            'actionType': entry.value['actionType'],
            'itemType': entry.value['itemType'],
            'timestamp': entry.value['timestamp'],
            'itemData': entry.value['itemData'],
          };
        }).toList();

        sortedActivities.sort((a, b) {
          final timestampA =
              (a['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
          final timestampB =
              (b['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
          return timestampB
              .compareTo(timestampA); // Sort descending by timestamp
        });

        activitiesList.addAll(sortedActivities);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch activities data: $e');
    } finally {
      isLoadingActivities.value = false;
    }
  }

  Future<void> fetchBorrowed() async {
    isLoadingBorrowed.value = true;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('history')
          .doc('borrowed')
          .get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        borrowedList.clear();

        final sortedBorrowed = data.entries.map((entry) {
          return {
            'id': entry.key,
            'user': entry.value['user'],
            'actionType': entry.value['actionType'],
            'itemType': entry.value['itemType'],
            'timestamp': entry.value['timestamp'],
            'itemData': entry.value['itemData'],
            'amount': entry.value['amount'],
            'categoryName': entry.value['categoryName']
          };
        }).toList();

        sortedBorrowed.sort((a, b) {
          final timestampA =
              (a['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
          final timestampB =
              (b['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
          return timestampB
              .compareTo(timestampA); // Sort descending by timestamp
        });

        borrowedList.addAll(sortedBorrowed);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch borrowed data: $e');
    } finally {
      isLoadingBorrowed.value = false;
    }
  }

  void onReturnClicked(String borrowedId) async {
    try {
      debugPrint('Memulai proses pengembalian barang untuk ID: $borrowedId');

      // Temukan data barang yang dipinjam dari `borrowedList` berdasarkan `borrowedId`
      final borrowedItem = borrowedList
          .firstWhere((item) => item['id'] == borrowedId, orElse: () {
        debugPrint(
            'Data pinjaman tidak ditemukan dalam borrowedList untuk ID: $borrowedId');
        return null;
      });

      if (borrowedItem != null) {
        final String categoryName = borrowedItem['categoryName'];
        final String toolsId = borrowedItem['itemData'].keys.first;
        final int returnAmount = borrowedItem['amount'] ?? 0;
        final String user = borrowedItem['user'] ?? '';
        final String name = borrowedItem['itemData'][toolsId]["name"];
        final int currentStock =
            borrowedItem['itemData'][toolsId]["stock"] ?? 0;

        final toolsRef =
            FirebaseFirestore.instance.collection('tools').doc(categoryName);

        if (returnAmount > 0) {
          final int newStock = currentStock + returnAmount;

          // Update stok baru di tools
          await toolsRef.update({
            '$toolsId.stock': newStock,
            '$toolsId.updatedAt': FieldValue.serverTimestamp(),
          });

          // Hapus entry dari dokumen `borrowed`
          await FirebaseFirestore.instance
              .collection('history')
              .doc('borrowed')
              .update({borrowedId: FieldValue.delete()});

          // Menampilkan snackbar sukses
          Get.snackbar('Success', 'Barang berhasil dikembalikan oleh $user');

          _logHistoryReturn(returnAmount, name);

          // Refresh data borrowed setelah pengembalian
          await fetchBorrowed();
        } else {
          Get.snackbar(
              'Error', 'Barang yang akan dikembalikan tidak ditemukan.');
        }
      } else {
        debugPrint('Error: Data pinjaman tidak ditemukan.');
        Get.snackbar('Error', 'Data pinjaman tidak ditemukan.');
      }
    } catch (e) {
      debugPrint('Terjadi error saat mengembalikan barang: $e');
      Get.snackbar('Error', 'Gagal mengembalikan barang: $e');
    }
  }

  Future<void> onRefreshActivities() async {
    await fetchActivities();
  }

  Future<void> onRefreshBorrowed() async {
    await fetchBorrowed();
  }

  Future<void> _getUserData() async {
    try {
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
          userName = data['name'] ?? '';
          update();
        } else {
          // Handle case where document does not exist
          userName = '';
          update();
        }
      }
      update();
    } catch (e) {
      debugPrint('Error getting profile data: $e');
    } finally {
      update();
    }
  }

  Future<void> _logHistoryReturn(
    int amount,
    String name,
  ) async {
    try {
      final borrowedId =
          const Uuid().v4(); // Generate a unique ID for the activity
      await FirebaseFirestore.instance
          .collection('history')
          .doc('activities')
          .set({
        borrowedId: {
          'user': userName,
          'itemType': "tools",
          'actionType': "return",
          'name': name,
          'amount': amount,
          'timestamp': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      log.e('Failed to log activity: $e');
    }
  }

  void onUnderDev() {
    const CustomSnackbar(
      success: false,
      title: 'Mohon maaf',
      message: 'Fitur ini sedang dalam pengembangan',
    ).showSnackbar();
  }
}
