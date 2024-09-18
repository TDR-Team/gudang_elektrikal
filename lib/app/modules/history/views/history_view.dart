import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Get.put(HistoryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: false,
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
                        Tab(text: 'Pinjaman'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          _buildTabContentActivities(
                            isLoading: controller.isLoadingActivities.value,
                            onRefreshActivities: controller.onRefreshActivities,
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
  }

  Widget _buildTabContentActivities({
    required bool isLoading,
    required Future<void> Function() onRefreshActivities,
  }) {
    return RefreshIndicator(
      onRefresh: onRefreshActivities,
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 0,
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
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.troubleshoot,
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
      child: Column(children: [
        const SizedBox(height: 8.0),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/img_waiting.svg'),
                Text(
                  'Belum ada Pinjaman',
                  style: boldText16.copyWith(
                    color: kColorScheme.primary,
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // Widget _buildTabContentBorrowed({
  //   required List<Borrowed> listJob,
  //   required bool isLoading,
  //   bool isActive = false,
  //   bool isHistory = false,
  //   String selectedStatus = '',
  //   List<String?> listElementStatus = const [],
  //   void Function(String? status)? onChangedStatus,
  //   required Future<void> Function() onRefreshActivity,
  // }) {
  //   return RefreshIndicator(
  //     onRefresh: onRefreshActivity,
  //     child: Column(
  //       children: [
  //         const SizedBox(height: 8.0),
  //         isLoading
  //             ? Expanded(
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                         children: List.generate(
  //                       5,
  //                       (index) => Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: ShimmerJobHorizontal(),
  //                       ),
  //                     )),
  //                   ),
  //                 ),
  //               )
  //             : listJob.isEmpty
  //                 ? Expanded(
  //                     child: Center(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           SvgPicture.asset('assets/images/img_waiting.svg'),
  //                           Text(
  //                             'Belum ada Aktivitas',
  //                             style: boldText16.copyWith(
  //                               color: kColorScheme.primary,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 150),
  //                         ],
  //                       ),
  //                     ),
  //                   )
  //                 : Expanded(
  //                     child: ListView.separated(
  //                       shrinkWrap: true,
  //                       padding: const EdgeInsets.only(
  //                         top: 8,
  //                         left: 16,
  //                         right: 16,
  //                         bottom: 0,
  //                       ),
  //                       itemBuilder: (context, index) {
  //                         return Column(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Flexible(
  //                                   flex: 2,
  //                                   child: Container(
  //                                     padding: const EdgeInsets.all(
  //                                       15,
  //                                     ),
  //                                     margin:
  //                                         const EdgeInsets.only(right: 10.0),
  //                                     decoration: BoxDecoration(
  //                                         color: Colors.red,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                     child: const Icon(
  //                                       Icons.troubleshoot,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 5,
  //                                   child: Container(
  //                                     margin: const EdgeInsets.only(right: 7.0),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           'Pinjam Tools',
  //                                           style: semiBoldText14,
  //                                         ),
  //                                         // enih harusnya style di pisah buat nama dan keterangan
  //                                         Text(
  //                                           'Agus - meminjam Kunci 8',
  //                                           style: regularText12.copyWith(
  //                                               color: Colors.grey),
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 3,
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.end,
  //                                     children: [
  //                                       Text(
  //                                         '8 menit lalu',
  //                                         style: regularText10,
  //                                       ),
  //                                       const SizedBox(height: 8.0),
  //                                       InkWell(
  //                                         onTap: () {},
  //                                         borderRadius:
  //                                             BorderRadius.circular(10),
  //                                         child: Container(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                               vertical: 6,
  //                                               horizontal: 12,
  //                                             ),
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.amber,
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10),
  //                                             ),
  //                                             child: Text(
  //                                               'Kembalikan',
  //                                               style: mediumText12,
  //                                             )),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         );
  //                       },
  //                       separatorBuilder: (context, index) => Divider(
  //                         indent: 50.w,
  //                         height: 20.h,
  //                       ),
  //                       itemCount: 0,
  //                     ),
  //                   ),
  //       ],
  //     ),
  //   );
  // }

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

  String formatTimestamp(Timestamp timestamp) {
    timeago.setLocaleMessages('id', CustomIdMessages());
    return timeago.format(timestamp.toDate(), locale: 'id');
  }
}
