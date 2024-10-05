import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/get_components_controller.dart';

import '../../../common/styles/colors.dart';
import '../../../common/theme/font.dart';
import '../../../widgets/dropdown_button.dart';

class GetComponentsView extends GetView<GetComponentsController> {
  const GetComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => GetComponentsController());
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
          'Ambil Komponen',
          style: semiBoldText20,
        ),
        surfaceTintColor: Colors.transparent,
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
                      image: AssetImage('assets/images/img_bgAppbar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Obx(
                //   () {
                //     // return _buildDropDown(
                //     //   listRack: controller.rackNames,
                //     //   onChangedRackName: controller.onChangedRackNames,
                //     // );
                //     return _buildDropDown(
                //       listRack: controller.rackNames,
                //       // onChangedRackName: (value) {
                //       //   if (value != null) {
                //       //     controller.onChangedRackNames(value);
                //       //   }
                //       // },
                //       onChangedRackName: controller.onChangedRackNames,
                //     );
                //   },
                // ),
                _buildDropDown(
                  listRack: controller.listRackNames,
                  // onChangedRackName: (value) {
                  //   if (value != null) {
                  //     controller.onChangedRackNames(value);
                  //   }
                  // },
                  onChangedRackName: controller.onChangedRackNames,
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                // Check if a rack is selected
                if (controller.rackName.value.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/shelf-stock.svg",
                          width: MediaQuery.sizeOf(context).width / 1.5,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pilih Rak untuk melihat level',
                          style: semiBoldText20,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  );
                }
                // If levels are loading
                if (controller.isLoadingLevels.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // If levels are fetched
                if (controller.listLevels.isNotEmpty) {
                  return _buildRackLevels(
                    context: context,
                    rackName: controller.rackName.value,
                    levels: controller.listLevels,
                    onLevelClicked: controller.onLevelClicked,
                  );
                } else {
                  return Center(
                    child: Text(
                      'Tidak ada laci untuk rak ini.',
                      style: semiBoldText20,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropDown({
    required var listRack,
    required void Function(String? value) onChangedRackName,
  }) {
    // List<String> updatedListRack = List.from(listRack)..add('Tambah Rak');

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropDown(
          listElement: listRack,
          hintText: 'Pilih Rak',
          // onChange: (value) {
          //   onChangedRackName(value);
          // },
          onChange: onChangedRackName,
          itemBuilder: (context, rackName, isSelected) {
            return ListTile(
              title: Text(rackName!),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRackLevels({
    required String rackName,
    required BuildContext context,
    required RxList levels,
    required void Function(String rackName, String levelName) onLevelClicked,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        top: 12,
        right: 0,
        left: 0,
        bottom: 100,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onLevelClicked(rackName, levels[index]),
          child: UnconstrainedBox(
            child: Container(
              width: MediaQuery.sizeOf(context).width / 1.1,
              decoration: BoxDecoration(
                color: kColorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      levels[index],
                      textAlign: TextAlign.center,
                      style: boldText28.copyWith(
                        color: Colors.white,
                        fontSize: 75.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: levels.length,
    );
  }
}
