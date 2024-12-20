import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../../../common/theme/font.dart';
import '../../../widgets/dropdown_button.dart';
import '../controllers/components_controller.dart';

class ComponentsView extends GetView<ComponentsController> {
  const ComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComponentsController>(
      init: ComponentsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: kColorScheme.surface,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'Komponen',
              style: semiBoldText24,
            ),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: PopupMenuButton<int>(
                  color: Colors.white,
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        controller.addRack();
                        break;
                      case 1:
                        if (controller.rackName.value.isNotEmpty) {
                          showEditRackDialog(
                            controller.rackName.value,
                            controller,
                          );
                        } else {
                          Get.snackbar('Error', 'Pilih rak terlebih dahulu.');
                        }
                        break;

                      case 2:
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Hapus Rak',
                                style: semiBoldText16,
                              ),
                              content: Text(
                                'Apakah anda yakin ingin menghapus rak ini?',
                                style: regularText12,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => controller
                                      .onDeleteRack(controller.rackName.value),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kColorScheme.error,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: kColorScheme.error,
                                      ),
                                    ),
                                    child: Text(
                                      'Hapus',
                                      style: semiBoldText12.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Batal',
                                    style: semiBoldText14.copyWith(
                                      color: kColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        break;
                    }
                  },
                  icon: Icon(
                    Icons.more_vert,
                    size: 24.sp,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('Tambah Rak'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Ubah Rak'),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text('Hapus Rak'),
                    ),
                  ],
                ),
              ),
            ],
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
                          image:
                              AssetImage('assets/images/img_components_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    _buildDropDown(
                      listRackNames: controller.listRackNames,
                      onChangedRackName: (value) {
                        if (value != null) {
                          controller.onChangedRackNames(value);
                        }
                      },
                      addRack: controller.addRack,
                      rackName: controller.rackName,
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
                        controller: controller,
                      );
                    } else {
                      return RefreshIndicator(
                        color: kColorScheme.primary,
                        onRefresh: () async {
                          controller.fetchLevelByRack(
                            controller.rackName.value,
                          );
                          controller.fetchRackNames();
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildAddLevelButton(controller),
                            const SizedBox(height: 20),
                            Expanded(
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 180.h,
                                              width: 80.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: Colors.grey,
                                              ),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 75,
                                                color: Color.fromARGB(
                                                    255, 53, 53, 53),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Belum ada Laci pada Rak ini',
                                          style: boldText16.copyWith(
                                            color: kColorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
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
            ],
          ),
        );
      },
    );
  }

  _buildAddLevelButton(ComponentsController controller) {
    return SizedBox(
      height: 40.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -20,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.primaryColors[0],
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.only(
                    left: 10,
                    right: 40,
                  ),
                ),
              ),
              onPressed: () {
                controller.addLevel();
              },
              label: const Text(
                'Laci',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropDown({
    required RxList listRackNames,
    required void Function(String? value) onChangedRackName,
    required RxString rackName,
    required void Function() addRack,
  }) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          () => DropDown(
            fillColor: Colors.white,
            hintText: 'Pilih Rak',
            listElement: listRackNames,
            selectedItem:
                rackName.value.isNotEmpty ? rackName.value : 'Pilih Rak',
            onChange: (value) {
              onChangedRackName(value);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            itemAsString: (item) => item ?? '',
            itemBuilder: (context, rackName, isSelected) {
              return ListTile(
                title: Text(rackName),
              );
            },
          ),
        ),
      ),
    );
  }

  void showEditRackDialog(
    String currentRackName,
    ComponentsController controller,
  ) {
    final match = RegExp(r'Rak (\d+)').firstMatch(currentRackName);
    final currentRackNumber = match?.group(1) ?? '';

    controller.customRackController.text = currentRackNumber;

    Get.dialog(
      AlertDialog(
        title: Text(
          'Ubah Nomor Rak',
          style: semiBoldText16,
        ),
        content: TextField(
          controller: controller.customRackController,
          style: semiBoldText14,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nomor Rak',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newRackNumber =
                  controller.customRackController.text.trim();
              if (newRackNumber.isEmpty) {
                Get.snackbar('Error', 'Nomor rak tidak boleh kosong.');
                return;
              }
              controller.onEditRack(currentRackName, newRackNumber);
              Navigator.pop(Get.context!);
            },
            child: Text(
              'Ubah',
              style: semiBoldText14.copyWith(
                color: kColorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRackLevels({
    required String rackName,
    required BuildContext context,
    required List levels,
    required void Function(String rackName, String levelName) onLevelClicked,
    required ComponentsController controller,
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
          if (index == 0) {
            return _buildAddLevelButton(controller);
          }
          final levelIndex = index - 1;
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
                        levels[levelIndex],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Laci ${levels[levelIndex]}',
                              style: boldText20.copyWith(
                                color: kColorScheme.primary,
                              ),
                            ),
                            _buildDeleteLevel(
                              context,
                              controller,
                              rackName,
                              levels,
                              levelIndex,
                            ),
                          ],
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
                                onLevelClicked(rackName, levels[levelIndex]);
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
                                'Lihat',
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
        itemCount: levels.length + 1,
      ),
    );
  }

  _buildDeleteLevel(BuildContext context, ComponentsController controller,
      String rackName, List<dynamic> levels, int levelIndex) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        switch (value) {
          case 0:
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Hapus Laci',
                    style: semiBoldText16,
                  ),
                  content: Text(
                    'Apakah anda yakin ingin menghapus laci ini?',
                    style: regularText12,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        controller.onDeleteLevel(
                          rackName,
                          levels[levelIndex],
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: kColorScheme.error,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: kColorScheme.error,
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: semiBoldText12.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Batal',
                        style: semiBoldText14.copyWith(
                          color: kColorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            break;
        }
      },
      icon: Icon(
        Icons.more_vert,
        size: 20.sp,
        color: kColorScheme.primary,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: Text('Hapus Laci'),
        ),
      ],
    );
  }
}
