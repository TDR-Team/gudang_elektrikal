import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';
import 'package:uuid/uuid.dart';
import 'package:gudang_elektrikal/app/common/helpers/custom_timeago.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  String formatActionType(String actionType) {
    switch (actionType) {
      case 'add':
        return 'menambahkan';
      case 'edit':
        return 'mengubah';
      case 'delete':
        return 'menghapus';
      case 'take':
        return 'mengambil';
      case 'borrow':
        return 'meminjam';
      case 'return':
        return 'mengembalikan';
      default:
        return actionType;
    }
  }

  String formatItemType(String itemType) {
    switch (itemType) {
      case 'components':
        return 'Komponen';
      case 'tools':
        return 'Alat';
      default:
        return itemType;
    }
  }

  String formatUser(String user) {
    return user.split(" ").first;
  }

  String formatTimestamp(Timestamp timestamp) {
    timeago.setLocaleMessages('id', CustomIdMessages());
    return timeago.format(timestamp.toDate(), locale: 'id');
  }

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
            'xName': entry.value['xName'],
            'xDescription': entry.value['xDescription'],
            'xAmount': entry.value['xAmount'],
            'xLocation': entry.value['xLocation'],
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
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal mengambil data aktivitas.',
      ).showSnackbar();
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
            'categoryName': entry.value['categoryName'],
            'name': entry.value['name']
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
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal mengambil data pinjaman.',
      ).showSnackbar();
    } finally {
      isLoadingBorrowed.value = false;
    }
  }

  void onReturnClicked(String borrowedId) async {
    try {
      // Temukan data barang yang dipinjam dari `borrowedList` berdasarkan `borrowedId`
      final borrowedItem = borrowedList
          .firstWhere((item) => item['id'] == borrowedId, orElse: () {
        return null;
      });

      if (borrowedItem != null) {
        final String categoryName = borrowedItem['categoryName'];
        final String toolsId = borrowedItem['itemData'];
        final int returnAmount = borrowedItem['amount'] ?? 0;
        final String user = borrowedItem['user'] ?? '';
        final String name = borrowedItem["name"] ?? "";
        final String description = borrowedItem["description"] ?? "";
        final String amount = borrowedItem["amount"].toString();
        final String category = borrowedItem["category"] ?? "";

        final toolsRef =
            FirebaseFirestore.instance.collection('tools').doc(categoryName);

        final toolsSnapshot = await toolsRef.get();
        final Map<String, dynamic>? toolsData = toolsSnapshot.data();
        final int currentStock = toolsData?[toolsId]?['stock'] ?? 0;

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
          CustomSnackbar(
            success: true,
            title: 'Berhasil',
            message: 'Barang berhasil dikembalikan oleh $user',
          ).showSnackbar();

          _logHistoryReturn(name, description, amount, category);

          // Refresh data borrowed setelah pengembalian
          await fetchBorrowed();
        } else {
          const CustomSnackbar(
            success: false,
            title: 'Gagal',
            message: 'Barang yang akan dikembalikan tidak ditemukan.',
          ).showSnackbar();
        }
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Data pinjaman tidak ditemukan.',
        ).showSnackbar();
      }
    } catch (e) {
      CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal mengembalikan barang: $e',
      ).showSnackbar();
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
    String name,
    String description,
    String amount,
    String category,
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
          'xName': name,
          'xDescription': description,
          'xAmount': amount,
          'xLocation': "Kategori $category",
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
