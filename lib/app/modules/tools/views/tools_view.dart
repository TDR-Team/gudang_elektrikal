import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/widgets/custom_list_components.dart';
import 'package:gudang_elektrikal/app/widgets/custom_list_tools.dart';
import 'package:gudang_elektrikal/app/widgets/custom_search.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/theme/font.dart';
import '../controllers/tools_controller.dart';

class ToolsView extends GetView<ToolsController> {
  const ToolsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ToolsController());
    return Scaffold(
      backgroundColor: kColorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Pinjam Alat',
          style: semiBoldText20,
        ),
        surfaceTintColor: Colors.transparent,
        // backgroundColor: kColorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
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
                        Container(
                          // width: ,
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const CustomListTools(
            id: "id",
            name: "name",
            imgUrl: "imgUrl",
            description: "description",
            stock: 8,
            tStock: 8,
            isStatus: true,
          ),
          const CustomListTools(
            id: "id",
            name: "name",
            imgUrl: "imgUrl",
            description: "description",
            stock: 0,
            tStock: 1,
            isStatus: false,
          ),
        ],
      ),
    );
  }
}
