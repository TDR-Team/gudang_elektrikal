import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/history/controllers/detail_activity_controller.dart';

class DetailActivityView extends GetView<DetailActivityController> {
  final String? user;
  final String? actionType;
  final String? itemType;
  final Timestamp? timestamp;
  final String? xName;
  final String? xDescription;
  final String? xAmount;
  final String? xLocation;

  const DetailActivityView({
    super.key,
    this.user,
    this.actionType,
    this.itemType,
    this.timestamp,
    this.xName,
    this.xDescription,
    this.xAmount,
    this.xLocation,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailActivityController>(
      init: DetailActivityController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Detail Aktivitas",
              style: semiBoldText20,
            ),
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
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: boldText14.copyWith(
                    color: AppColors.neutralColors[1],
                  ),
                ),
                Text(
                  controller.formatUser(user ?? 'hallo'),
                  style: semiBoldText14.copyWith(
                    color: AppColors.neutralColors[2],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nama ${controller.formatItemType(itemType!)}',
                  style: boldText14.copyWith(
                    color: AppColors.neutralColors[1],
                  ),
                ),
                Text(
                  xName ?? '',
                  style: semiBoldText14.copyWith(
                    color: AppColors.neutralColors[2],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Banyaknya',
                  style: boldText14.copyWith(
                    color: AppColors.neutralColors[1],
                  ),
                ),
                RichText(
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    text: "",
                    style: regularText14.copyWith(
                      color: AppColors.neutralColors[1],
                    ),
                    children: [
                      TextSpan(
                        text: xAmount,
                        style: semiBoldText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Lokasi',
                  style: boldText14.copyWith(
                    color: AppColors.neutralColors[1],
                  ),
                ),
                RichText(
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    text: "",
                    style: regularText14.copyWith(
                      color: AppColors.neutralColors[1],
                    ),
                    children: [
                      // location
                      TextSpan(
                        text: xLocation,
                        style: semiBoldText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Keterangan',
                  style: boldText14.copyWith(
                    color: AppColors.neutralColors[1],
                  ),
                ),
                RichText(
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    text: "",
                    style: regularText14.copyWith(
                      color: AppColors.neutralColors[1],
                    ),
                    children: [
                      TextSpan(
                        text: controller
                            .formatActionType(actionType!)
                            .capitalizeFirst,
                        style: regularText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: regularText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      // amount
                      TextSpan(
                        text: xAmount,
                        style: semiBoldText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: regularText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      // name
                      TextSpan(
                        text: xName,
                        style: semiBoldText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      TextSpan(
                        text: ' pada ',
                        style: regularText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      // itemType
                      TextSpan(
                        text: controller.formatItemType(itemType!),
                        style: semiBoldText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      TextSpan(
                        text: " di ",
                        style: regularText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                      // location
                      TextSpan(
                        text: xLocation,
                        style: semiBoldText14.copyWith(
                          color: AppColors.neutralColors[2],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Waktu',
                  style: semiBoldText14.copyWith(
                    color: AppColors.neutralColors[1],
                  ),
                ),
                Text(
                  timestamp!.toDate().toString(),
                  style: regularText14.copyWith(
                    color: AppColors.neutralColors[2],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
