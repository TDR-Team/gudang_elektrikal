import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/data/model/activity.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isLoggedIn = true.obs;
  final isLoadingBorrowed = false.obs;
  final isLoadingHistory = false.obs;
  // final isLoadingActive = false.obs;
  // final isLoadingWaiting = true.obs;
  // final isLoadingOffering = true.obs;
  // final isLoadingHistory = true.obs;

  final dataBorrowed = <Activity>[].obs;
  final dataHistory = <Activity>[].obs;

  // final jobDataActive = <JobData>[].obs;
  // final jobDataWaiting = <JobData>[].obs;
  // final jobDataOffering = <JobData>[].obs;
  // final jobDataHistory = <JobData>[].obs;
  // final jobData = <JobData>[].obs;

  final selectedIndex = 0.obs;
  late TabController tabController;

  final selectedStatus = 'Semua Status'.obs;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabChange);
    // checkLoginStatus();
    super.onInit();
    loadDataForTab(0);
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    super.onClose();
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      loadDataForTab(tabController.index);
    }
  }

  Future<void> loadDataForTab(int index) async {
    switch (index) {
      case 0:
        await fetchActivity(
          status: 'pinjaman',
          isLoading: isLoadingBorrowed,
          dataList: dataBorrowed,
        );
        break;
      case 1:
        await fetchActivity(
          status: 'riwayat',
          isLoading: isLoadingHistory,
          dataList: dataHistory,
        );
        break;

      default:
        break;
    }
  }

  // Future<void> checkLoginStatus() async {
  //   var token = await get_utils.GetUtils().getUserToken();
  //   isLoggedIn.value = token.isNotEmpty;
  // }

  Future<void> fetchActivity({
    required String status,
    required RxBool isLoading,
    required RxList<Activity> dataList,
    String statusFilter = '',
  }) async {
    isLoading.value = true;
    try {
      // final activityService = ActivityService();
      // var data = await activityService.getActivity(status: status);

      // ac.value = statusFilter != ''
      //     ? data
      //         .where(
      //             (element) => element.statusName.toUpperCase() == statusFilter)
      //         .toList()
      //     : data;
    } catch (e) {
      log.e('Error fetching $status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefreshBorrowed() async {
    await fetchActivity(
      status: 'pinjaman',
      isLoading: isLoadingBorrowed,
      dataList: dataBorrowed,
    );
  }

  Future<void> onRefreshHistory() async {
    await fetchActivity(
      status: 'riwayat',
      isLoading: isLoadingHistory,
      dataList: dataHistory,
    );
  }
}
