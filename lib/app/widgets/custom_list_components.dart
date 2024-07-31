import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:shimmer/shimmer.dart';

class CustomListComponents extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final int stock;
  final String unit;
  final void Function()? onTapDetail;
  final void Function()? onTapEdit;

  const CustomListComponents({
    super.key,
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.stock,
    required this.unit,
    this.onTapDetail,
    this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTapDetail,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
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
                      baseColor: const Color.fromARGB(255, 148, 148, 148),
                      highlightColor: const Color.fromARGB(255, 102, 95, 95),
                      child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 30,
                      color: Color.fromARGB(255, 53, 53, 53),
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
                    overflow: TextOverflow.ellipsis,
                    style: boldText18,
                    textScaler: const TextScaler.linear(1),
                  ),
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: regularText10,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$stock $unit',
                    style: semiBoldText14,
                    textScaler: const TextScaler.linear(1),
                  ),
                ),
                IconButton(
                  onPressed: onTapEdit,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
