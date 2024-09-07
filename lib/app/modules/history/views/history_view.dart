import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/data/model/borrowed.dart';
import 'package:gudang_elektrikal/app/widgets/not_logged_in.dart';
import 'package:gudang_elektrikal/app/widgets/shimmer/shimmer_job_horizontal.dart';

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
            if (controller.isLoggedIn.value) {
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
                          _buildTabContentHistory(
                            isLoading: controller.isLoadingHistory.value,
                            listJob: controller.dataHistory,
                            onRefreshActivity: controller.onRefreshHistory,
                          ),
                          _buildTabContentBorrowed(
                            isLoading: controller.isLoadingBorrowed.value,
                            isActive: true,
                            listJob: controller.dataBorrowed,
                            onRefreshActivity: controller.onRefreshBorrowed,
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

  Widget _buildTabContentBorrowed({
    required List<Borrowed> listJob,
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 0,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        15,
                                      ),
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.troubleshoot,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 7.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pinjam Tools',
                                            style: semiBoldText14,
                                          ),
                                          // enih harusnya style di pisah buat nama dan keterangan
                                          Text(
                                            'Agus - meminjam Kunci 8',
                                            style: regularText12.copyWith(
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '8 menit lalu',
                                          style: regularText10,
                                        ),
                                        const SizedBox(height: 8.0),
                                        InkWell(
                                          onTap: () {},
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
                        itemCount: controller.dataBorrowed.length,
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildTabContentHistory({
    required List<Borrowed> listJob,
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 0,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        15,
                                      ),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.troubleshoot,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tambah Komponen',
                                          style: semiBoldText14,
                                        ),
                                        // enih harusnya style di pisah buat nama dan keterangan
                                        Text(
                                          '8 Meter Kabel ditambahkan ke Rak 1',
                                          style: regularText12.copyWith(
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      '8 menit lalu',
                                      style: regularText10,
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
                        itemCount: controller.dataBorrowed.length,
                      ),
                    ),
        ],
      ),
    );
  }
}
