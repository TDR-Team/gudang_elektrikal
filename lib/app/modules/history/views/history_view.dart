import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/helpers/custom_timeago.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/widgets/shimmer/shimmer_job_horizontal.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      init: HistoryController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Riwayat',
              style: semiBoldText20,
            ),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Obx(
              () {
                if (true) {
                  return DefaultTabController(
                    initialIndex: 1,
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          controller: controller.tabController,
                          labelStyle: semiBoldText14,
                          labelColor: kColorScheme.primary,
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          indicatorColor: const Color(0xFF0E5970),
                          unselectedLabelColor:
                              const Color.fromARGB(255, 25, 27, 27),
                          tabs: const [
                            Tab(text: 'Aktivitas'),
                            Tab(text: 'Peminjaman'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [
                              _buildTabContentActivities(
                                isLoading: controller.isLoadingActivities.value,
                                onRefreshActivities:
                                    controller.onRefreshActivities,
                              ),
                              _buildTabContentBorrowed(
                                isLoading: controller.isLoadingBorrowed.value,
                                onRefreshBorrowed: controller.onRefreshBorrowed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabContentActivities({
    required bool isLoading,
    required Future<void> Function() onRefreshActivities,
  }) {
    return RefreshIndicator(
      onRefresh: onRefreshActivities,
      color: kColorScheme.primary,
      child: Column(
        children: [
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
              : controller.activitiesList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/img_empty.png',
                                  fit: BoxFit.fitHeight,
                                  height: 180.h,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 180.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.grey,
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 75,
                                        color: Color.fromARGB(255, 53, 53, 53),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada Aktivitas',
                                  style: boldText16.copyWith(
                                    color: kColorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 30,
                        ),
                        itemBuilder: (context, index) {
                          final activity = controller.activitiesList[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: activity['itemType'] == 'tools'
                                          ? kColorScheme.primary
                                          : AppColors.secondaryColors[2],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      activity['itemType'] == 'tools'
                                          ? Icons.build_outlined
                                          : Icons.all_inbox,
                                      color: activity['itemType'] == 'tools'
                                          ? kColorScheme.secondary
                                          : kColorScheme.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatItemType(
                                                  activity['itemType']),
                                              style: semiBoldText16,
                                            ),
                                            Text(
                                              formatTimestamp(
                                                  activity['timestamp']),
                                              style: regularText10,
                                            ),
                                          ],
                                        ),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: activity['user'],
                                            style: semiBoldText12.copyWith(
                                                color:
                                                    AppColors.neutralColors[1]),
                                            children: [
                                              TextSpan(
                                                text: ' ',
                                                style: regularText12.copyWith(
                                                    color: AppColors
                                                        .neutralColors[2]),
                                              ),
                                              TextSpan(
                                                text: formatActionType(
                                                    activity['actionType']),
                                                style: regularText12.copyWith(
                                                    color: AppColors
                                                        .neutralColors[2]),
                                              ),
                                              TextSpan(
                                                text: ' pada ',
                                                style: regularText12.copyWith(
                                                    color: AppColors
                                                        .neutralColors[2]),
                                              ),
                                              TextSpan(
                                                text: formatItemType(
                                                    activity['itemType']),
                                                style: regularText12.copyWith(
                                                    color: AppColors
                                                        .neutralColors[1]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          indent: 50.w,
                          height: 20.h,
                        ),
                        itemCount: controller.activitiesList.length,
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildTabContentBorrowed({
    required bool isLoading,
    required Future<void> Function() onRefreshBorrowed,
  }) {
    return RefreshIndicator(
      onRefresh: onRefreshBorrowed,
      color: kColorScheme.primary,
      child: Column(
        children: [
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
              : controller.borrowedList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/img_empty.png',
                                  fit: BoxFit.fitHeight,
                                  height: 180.h,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 180.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.grey,
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 75,
                                        color: Color.fromARGB(255, 53, 53, 53),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada Peminjaman',
                                  style: boldText16.copyWith(
                                    color: kColorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 30,
                        ),
                        itemBuilder: (context, index) {
                          final borrowed = controller.borrowedList[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: kColorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.build_outlined,
                                          color: kColorScheme.secondary,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pinjam Tools',
                                              style: semiBoldText14,
                                            ),
                                            SizedBox(
                                              width: 145.w,
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text: formatUser(
                                                      borrowed['user']),
                                                  style: semiBoldText12.copyWith(
                                                      color: AppColors
                                                          .neutralColors[1]),
                                                  children: [
                                                    TextSpan(
                                                      text: ' ',
                                                      style: regularText12.copyWith(
                                                          color: AppColors
                                                              .neutralColors[2]),
                                                    ),
                                                    TextSpan(
                                                      text: formatActionType(
                                                          borrowed[
                                                              'actionType']),
                                                      style: regularText12.copyWith(
                                                          color: AppColors
                                                              .neutralColors[2]),
                                                    ),
                                                    TextSpan(
                                                      text: " ",
                                                      style: regularText12.copyWith(
                                                          color: AppColors
                                                              .neutralColors[2]),
                                                    ),
                                                    TextSpan(
                                                      text: borrowed['amount']
                                                          .toString(),
                                                      style: regularText12.copyWith(
                                                          color: AppColors
                                                              .neutralColors[1]),
                                                    ),
                                                    TextSpan(
                                                      text: " ",
                                                      style: regularText12.copyWith(
                                                          color: AppColors
                                                              .neutralColors[2]),
                                                    ),
                                                    TextSpan(
                                                      text: borrowed['name'],
                                                      style: regularText12.copyWith(
                                                          color: AppColors
                                                              .neutralColors[1]),
                                                    ),
                                                    // TextSpan(
                                                    //   text: formatItemType(
                                                    //       borrowed['itemType']),
                                                    //   style: regularText12.copyWith(
                                                    //       color: AppColors
                                                    //           .neutralColors[1]),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    // flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formatTimestamp(
                                              borrowed['timestamp']),
                                          style: regularText10,
                                        ),
                                        const SizedBox(height: 8.0),
                                        InkWell(
                                          onTap: () {
                                            controller.onReturnClicked(
                                                borrowed['id']);
                                            debugPrint(borrowed['id']);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'Kembalikan',
                                                style: mediumText12,
                                              )),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          indent: 50.w,
                          height: 20.h,
                        ),
                        itemCount: controller.borrowedList.length,
                      ),
                    ),
        ],
      ),
    );
  }

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
}
