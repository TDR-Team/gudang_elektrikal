import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/data/model/activity.dart';
import 'package:gudang_elektrikal/app/widgets/not_logged_in.dart';
import 'package:gudang_elektrikal/app/widgets/shimmer/shimmer_job_horizontal.dart';

import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ActivityController());
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoggedIn.value) {
              return DefaultTabController(
                initialIndex: 1,
                length: 4,
                child: Column(
                  children: [
                    TabBar(
                      controller: controller.tabController,
                      labelStyle: semiBoldText14,
                      labelColor: kColorScheme.primary,
                      padding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicatorColor: const Color(0xFF0E5970),
                      unselectedLabelColor: Color.fromARGB(255, 25, 27, 27),
                      tabs: const [
                        Tab(text: 'Pinjaman'),
                        Tab(text: 'Riwayat'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          _buildTabContent(
                            isLoading: controller.isLoadingBorrowed.value,
                            isActive: true,
                            listJob: controller.dataBorrowed,
                            onRefreshActivity: controller.onRefreshBorrowed,
                          ),
                          _buildTabContent(
                            isLoading: controller.isLoadingHistory.value,
                            listJob: controller.dataHistory,
                            onRefreshActivity: controller.onRefreshHistory,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: NotLoggedIn(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required List<Activity> listJob,
    required bool isLoading,
    bool isActive = false,
    bool isHistory = false,
    String selectedStatus = '',
    List<String?> listElementStatus = const [],
    void Function(String? status)? onChangedStatus,
    required Future<void> Function() onRefreshActivity,
  }) {
    return RefreshIndicator(
      onRefresh: onRefreshActivity,
      child: Column(
        children: [
          Visibility(
            visible: isHistory,
            child: const SizedBox(height: 8.0),
          ),
          Visibility(
            visible: isHistory,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: selectedStatus,
                items: listElementStatus
                    .map(
                      (element) => DropdownMenuItem<String>(
                        value: element,
                        child: Text(
                          element ?? '',
                          style: mediumText12,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChangedStatus,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
                iconSize: 28,
                isExpanded: true,
                underline: const SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          isLoading
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ShimmerJobHorizontal(),
                        ),
                      )),
                    ),
                  ),
                )
              : listJob.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/img_waiting.svg'),
                            Text(
                              'Belum ada Aktivitas',
                              style: boldText16.copyWith(
                                color: kColorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: listJob.map((job) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                // child: CardJobHorizontal(
                                //   jobData: job,
                                //   showJobNowState: isActive,
                                //   showStatus: isHistory,
                                // ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
