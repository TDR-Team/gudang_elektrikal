import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/list_components_controller.dart';
import 'package:gudang_elektrikal/app/widgets/custom_list_components.dart';
import 'package:gudang_elektrikal/app/widgets/custom_list_get_component.dart';
import 'package:gudang_elektrikal/app/widgets/custom_search.dart';

class ListComponentsView extends GetView<ListComponentsController> {
  const ListComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ListComponentsController());

    return Scaffold(
      backgroundColor: kColorScheme.surface,
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
                        'assets/images/img_bgAppbar.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      controller.levelName,
                      style: boldText28.copyWith(
                        color: Colors.white,
                        fontSize: 48.sp,
                      ),
                      textScaler: const TextScaler.linear(1),
                    ),
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearch(
                      searchController: controller.searchController,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.searchController.text.isNotEmpty &&
                  controller.filteredComponents.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada komponen yang dicari',
                    style: semiBoldText16.copyWith(
                      color: AppColors.primaryColors[1],
                    ),
                  ),
                );
              } else if (controller.filteredComponents.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/ic_emptyBox.svg'),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Laci ${controller.levelName} belum memiliki komponen',
                        style: semiBoldText16.copyWith(
                          color: AppColors.primaryColors[1],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 16,
                    right: 16,
                    bottom: 0,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: controller.filteredComponents.length,
                  itemBuilder: (context, index) {
                    var component = controller.filteredComponents[index];
                    return controller.isGetComponent
                        ? CustomListGetComponent(
                            id: component['id'],
                            name: component['name'],
                            imgUrl: component['imgUrl'],
                            description: component['description'],
                            stock: component['stock'],
                            unit: component['unit'],
                            onTapGetComponent: () {
                              controller.onGetComponentClicked(component['id']);
                            },
                            stockController: controller.stockController,
                            stockFocusNode: controller.stockFocusNode,
                            onIncrementButton: () {
                              controller.increment(component['id']);
                            },
                            onDecrementButton: () =>
                                controller.decrement(component['id']),
                          )
                        : CustomListComponents(
                            id: component['id'],
                            name: component['name'],
                            imgUrl: component['imgUrl'],
                            description: component['description'],
                            stock: component['stock'],
                            unit: component['unit'],
                            onTapEdit: () {
                              controller
                                  .onEditComponentClicked(component['id']);
                            },
                            onTapDelete: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Apakah anda yakin?',
                                      style: semiBoldText16,
                                    ),
                                    content: Text(
                                      'Komponen ini akan dihapus',
                                      style: regularText12,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          controller.onDeleteComponentClicked(
                                            component['id'],
                                            !controller.isGetComponent,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              color: kColorScheme.error,
                                            ),
                                          ),
                                          child: Text(
                                            'Hapus',
                                            style: semiBoldText12.copyWith(
                                              color: kColorScheme.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(
                                          'Kembali',
                                          style: semiBoldText12,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              // controller.onDeleteComponentClicked(
                              //   component['id'],
                              //   !controller.isGetComponent,
                              // );
                            },
                          );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0 &&
            !controller.isGetComponent,
        child: FloatingActionButton(
          onPressed: () {
            controller.onAddComponentClicked();
          },
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
