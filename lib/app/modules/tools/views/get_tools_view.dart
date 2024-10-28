import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/modules/tools/controllers/get_tools_controller.dart';
import 'package:gudang_elektrikal/app/widgets/custom_get_tools.dart';
import 'package:gudang_elektrikal/app/widgets/custom_search.dart';

import '../../../common/theme/font.dart';

class GetToolsView extends GetView<GetToolsController> {
  const GetToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetToolsController>(
      init: GetToolsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: kColorScheme.surface,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              padding: const EdgeInsets.all(16),
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24.sp,
                color: Colors.black,
              ),
            ),
            title: Text(
              'Pinjam Alat',
              style: semiBoldText20,
            ),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150.h,
                child: Stack(
                  children: [
                    Container(
                      height: 130.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kColorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/img_bgTools.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: CustomSearch(
                                searchController: controller.searchController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: controller.onUnderDev,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.tune,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kColorScheme.primary,
                      ),
                    );
                  } else if (controller.categorizedTools.isEmpty) {
                    return RefreshIndicator(
                      color: kColorScheme.primary,
                      onRefresh: () async {
                        controller.fetchTools();
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: Column(
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
                                  'Alat tidak ditemukan',
                                  style: boldText16.copyWith(
                                    color: kColorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      color: kColorScheme.primary,
                      onRefresh: () async {
                        controller.fetchTools();
                      },
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          top: 12.h,
                          left: 16.w,
                          right: 16.w,
                          bottom: 0.h,
                        ),
                        children:
                            controller.categorizedTools.entries.map((entry) {
                          String categoryName = entry.key;
                          List<Map<String, dynamic>> toolsList = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: semiBoldText16,
                              ),
                              SizedBox(height: 5.h),
                              ...toolsList.map((tools) {
                                return CustomGetTools(
                                  id: tools['id'],
                                  name: tools['name'],
                                  imgUrl: tools['imgUrl'] ??
                                      'https://picsum.photos/200/300',
                                  description: tools['description'] ??
                                      'No description available',
                                  stock: tools['stock'],
                                  tStock: tools['tStock'],
                                  isStatus: tools['stock'] != 0,
                                  onTapGetTools: () {
                                    controller.onGetToolsClicked(
                                        categoryName, tools['id']);
                                  },
                                  stockController: controller.stockController,
                                  stockFocusNode: controller.stockFocusNode,
                                  onIncrementButton: () => controller.increment(
                                      categoryName, tools['id']),
                                  onDecrementButton: () => controller.decrement(
                                      categoryName, tools['id']),
                                  isLoading: controller.isLoadingGetTools.value,
                                );
                              }),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
