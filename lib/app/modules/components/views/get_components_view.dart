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
    return GetBuilder<GetComponentsController>(
      init: GetComponentsController(),
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
                          image: AssetImage(
                            'assets/images/img_components_bg.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    _buildDropDown(
                      listRack: controller.listRackNames,
                      onChangedRackName: controller.onChangedRackNames,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () {
                    // If levels are loading
                    if (controller.isLoadingLevels.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: kColorScheme.primary,
                        ),
                      );
                    }

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
      },
    );
  }

  Widget _buildDropDown({
    required var listRack,
    required void Function(String? value) onChangedRackName,
  }) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropDown(
          listElement: listRack,
          hintText: 'Pilih Rak',
          onChange: onChangedRackName,
          selectedItem: controller.rackName.value.isNotEmpty
              ? controller.rackName.value
              : 'Pilih Rak',
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
    required List levels,
    required void Function(String rackName, String levelName) onLevelClicked,
    // required ComponentsController controller,
  }) {
    return RefreshIndicator(
      color: kColorScheme.primary,
      onRefresh: () async {
        controller.fetchRackNames();
        controller.fetchLevelByRack(rackName);
      },
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: 12,
          right: 0,
          left: 0,
          bottom: 100,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              color: const Color.fromARGB(255, 249, 253, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.centerRight,
                          colors: [
                            kColorScheme.primary,
                            kColorScheme.primary.withOpacity(0.85),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        levels[index],
                        style: boldText28.copyWith(
                          fontSize: 45.sp,
                          color: kColorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Laci ${levels[index]}',
                          style: boldText20.copyWith(
                            color: kColorScheme.primary,
                          ),
                        ),
                        Divider(
                          color: kColorScheme.primary,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              onPressed: () {
                                onLevelClicked(rackName, levels[index]);
                              },
                              style: ButtonStyle(
                                foregroundColor: const WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  kColorScheme.secondary,
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsetsDirectional.only(
                                    start: 12,
                                    end: 16,
                                  ),
                                ),
                              ),
                              label: Text(
                                'Ambil',
                                style: semiBoldText14.copyWith(
                                  color: kColorScheme.primary,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18.sp,
                                color: kColorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                        .marginSymmetric(
                          horizontal: 16,
                        )
                        .paddingOnly(bottom: 4),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: levels.length,
      ),
    );
  }
}
