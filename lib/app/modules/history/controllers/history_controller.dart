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

        data.forEach((activityId, activityData) {
          activitiesList.add({
            'id': activityId,
            'user': activityData['user'],
            'actionType': activityData['actionType'],
            'itemType': activityData['itemType'],
            'timestamp': activityData['timestamp'],
            'itemData': activityData['itemData']
          });
        });
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

        data.forEach((borrowedId, borrowedData) {
          borrowedList.add({
            'id': borrowedId,
            'user': borrowedData['user'],
            'actionType': borrowedData['actionType'],
            'itemType': borrowedData['itemType'],
            'timestamp': borrowedData['timestamp'],
            'itemData': borrowedData['itemData']
          });
        });
      }
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
