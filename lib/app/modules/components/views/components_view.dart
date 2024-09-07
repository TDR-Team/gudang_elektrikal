import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../../../common/theme/font.dart';
import '../../../widgets/dropdown_button.dart';
import '../controllers/components_controller.dart';

class ComponentsView extends GetView<ComponentsController> {
  const ComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    ComponentsController controller = Get.put(ComponentsController());

    return Scaffold(
      backgroundColor: kColorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Komponen',
          style: semiBoldText20,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopupMenuButton<int>(
              onSelected: (value) {
                switch (value) {
                  case 0:
                    controller.addRack();
                    break;
                  case 1: // Edit Rack
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
                            'Apakah anda yakin?',
                            style: semiBoldText16,
                          ),
                          content: Text(
                            'Rak ini akan dihapus',
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
                                  borderRadius: BorderRadius.circular(50),
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
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                'Kembali',
                                style: semiBoldText12,
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
                      image: AssetImage('assets/images/img_bgAppbar.png'),
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
                // Check if a rack is selected
                if (controller.rackName.value.isEmpty) {
                  return Center(
                    child: Text(
                      'Pilih Rak untuk melihat level',
                      style: semiBoldText20,
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
                    controller: controller,
                  );
                } else {
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          controller.addLevel();
                        },
                        label: const Text('Tambah Laci'),
                        icon: const Icon(Icons.add),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Tidak ada level untuk rak ini.',
                              style: semiBoldText20,
                            ),
                          ),
                        ],
                      ),
                    ],
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
            hintText: 'Pilih Rak',
            listElement: listRackNames,
            selectedItem:
                rackName.value.isNotEmpty ? rackName.value : 'Pilih Rak',
            onChange: (value) {
              onChangedRackName(value);
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
              String newRackName = 'Rak $newRackNumber';
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
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        top: 12,
        right: 0,
        left: 0,
        bottom: 100,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return TextButton.icon(
            onPressed: () {
              controller.addLevel();
            },
            label: const Text('Tambah Laci'),
            icon: const Icon(Icons.add),
          );
        }

        // For other levels
        final levelIndex = index - 1; // Adjust index for other levels
        return GestureDetector(
          onTap: () => onLevelClicked(rackName, levels[levelIndex]),
          child: UnconstrainedBox(
            child: Container(
              width: MediaQuery.sizeOf(context).width / 1.1,
              decoration: BoxDecoration(
                color: kColorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 5,
                    top: 5,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Apakah anda yakin?',
                                style: semiBoldText16,
                              ),
                              content: Text(
                                'Laci ini akan dihapus',
                                style: regularText12,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => controller.onDeleteLevel(
                                    rackName,
                                    levels[levelIndex],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
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
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      levels[levelIndex],
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
      itemCount: levels.length + 1,
    );
  }
}
