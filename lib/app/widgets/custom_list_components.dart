import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:shimmer/shimmer.dart';

class CustomListComponents extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final String? description;
  final int stock;
  final String unit;
  final void Function()? onTapDetail;
  final void Function()? onTapEdit;
  final void Function()? onTapDelete;

  const CustomListComponents({
    super.key,
    required this.id,
    required this.name,
    required this.imgUrl,
    this.description,
    required this.stock,
    required this.unit,
    this.onTapDetail,
    this.onTapEdit,
    this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    print(
      'Description: $description , isEmpty: ${description!.isEmpty}',
    );
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 80.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.neutralColors[3],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imgUrl,
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 148, 148, 148),
                                highlightColor:
                                    const Color.fromARGB(255, 102, 95, 95),
                                child: Container(
                                  height: 60.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                size: 125.sp,
                                color: const Color.fromARGB(255, 53, 53, 53),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              name,
                              maxLines: 5,
                              style: boldText20,
                              overflow: TextOverflow.ellipsis,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warningColors,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$stock $unit',
                              style: semiBoldText14.copyWith(
                                color: AppColors.neutralColors[0],
                              ),
                              textScaler: const TextScaler.linear(1),
                            ),
                          ),
                        ],
                      ),
                      if (description != null && description!.trim().isNotEmpty)
                        Column(
                          children: [
                            Text(
                              description ?? 'No description available',
                              style: regularText10.copyWith(
                                color: AppColors.neutralColors[2],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: onTapEdit,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColors[0],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Edit',
                                  style: semiBoldText16.copyWith(
                                    color: AppColors.onSecondaryColors[2],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: onTapDelete,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.errorColors,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: AppColors.onPrimaryColors[0],
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imgUrl,
                height: 60.h,
                width: 60.w,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Shimmer.fromColors(
                      baseColor: AppColors.neutralColors[2],
                      highlightColor: AppColors.neutralColors[1],
                      child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: AppColors.neutralColors[3].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 60.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.neutralColors[3],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 30,
                      color: AppColors.neutralColors[1],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines:
                        description != null && description!.trim().isNotEmpty
                            ? 1
                            : 2,
                    overflow: TextOverflow.ellipsis,
                    style: boldText18.copyWith(
                      color: AppColors.neutralColors[1],
                    ),
                    textScaler: const TextScaler.linear(1),
                  ),
                  if (description != null && description!.trim().isNotEmpty)
                    Text(
                      description!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: regularText10.copyWith(
                        color: AppColors.neutralColors[2],
                      ),
                      textScaler: const TextScaler.linear(1),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.h,
                    vertical: 3.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColors[0],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$stock $unit',
                    style: semiBoldText12.copyWith(
                      color: AppColors.neutralColors[1],
                    ),
                    textScaler: const TextScaler.linear(1),
                  ),
                ),
                IconButton(
                  onPressed: onTapEdit,
                  icon: Icon(
                    Icons.edit,
                    size: 18.h,
                    color: AppColors.neutralColors[2],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
