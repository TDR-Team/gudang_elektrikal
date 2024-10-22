import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isLoadingBorrowed = false.obs;
  final isLoadingActivities = false.obs;

  final activitiesList = [].obs;
  final borrowedList = [].obs;

  final selectedIndex = 0.obs;
  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabChange);
    fetchActivities();
    fetchBorrowed();
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

        // Convert data map to a list and sort it by timestamp
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
      borrowedList.add({});
      // final snapshot = await FirebaseFirestore.instance
      //     .collection('history')
      //     .doc('borrowed')
      //     .get();
      // if (snapshot.exists) {
      //   final data = snapshot.data()!;
      //   borrowedList.clear();

      //   data.forEach((borrowedId, borrowedData) {
      //     borrowedList.add({
      //       'id': borrowedId,
      //       'user': borrowedData['user'],
      //       'actionType': borrowedData['actionType'],
      //       'itemType': borrowedData['itemType'],
      //       'timestamp': borrowedData['timestamp'],
      //       'itemData': borrowedData['itemData']
      //     });
      //   });
      // }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch borrowed data: $e');
    } finally {
      isLoadingBorrowed.value = false;
    }
  }

  Future<void> onRefreshActivities() async {
    await fetchActivities();
  }

  Future<void> onRefreshBorrowed() async {
    await fetchBorrowed();
  }
}
