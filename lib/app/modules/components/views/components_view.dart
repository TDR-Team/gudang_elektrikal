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
    Get.lazyPut(() => ComponentsController());
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
            child: IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text(
                      'Tambah Laci',
                      style: semiBoldText16,
                    ),
                    content: TextField(
                      controller: controller.customLevelController,
                      style: semiBoldText14,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nomor Laci',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          String customLevelName =
                              controller.customLevelController.text;
                          controller.addLevel(customLevelName);
                        },
                        child: Text(
                          'Tambah',
                          style: semiBoldText14.copyWith(
                            color: kColorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                size: 24.sp,
                color: Colors.black,
              ),
            ),
          )
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
                  listRack: controller.rackNames,
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
                  );
                } else {
                  return Center(
                    child: Text(
                      'Tidak ada level untuk rak ini.',
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

  _buildDropDown({
    required List<String> listRack,
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
          // onChange: (value) async {
          //   if (value == 'Tambah Rak Baru') {
          //     // Trigger the "Add New Rack" dialog
          //     String? newRackName = await Get.dialog<String>(
          //       AlertDialog(
          //         title: Text(
          //           'Tambah Rak',
          //           style: semiBoldText16,
          //         ),
          //         content: TextField(
          //           controller: TextEditingController(),
          //           style: semiBoldText14,
          //           decoration: const InputDecoration(
          //             border: OutlineInputBorder(),
          //             labelText: 'Nama Rak',
          //           ),
          //         ),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               // Retrieve the entered rack name from the TextField
          //               String customRackName =
          //                   Get.find<TextEditingController>().text;
          //               // Close the dialog and return the rack name
          //               Get.back(result: customRackName);
          //             },
          //             child: Text(
          //               'Tambah',
          //               style: semiBoldText14.copyWith(
          //                 color: kColorScheme.primary,
          //               ),
          //             ),
          //           ),
          //         ],aa
          //       ),
          //     );

          //     if (newRackName != null && newRackName.isNotEmpty) {
          //       // Add the new rack to the list and trigger the onChange callback
          //       listRack.add(newRackName);
          //       onChangedRackName(newRackName);
          //     }
          //   } else {
          //     // Otherwise, trigger the normal onChange callback
          //     onChangedRackName(value);
          //   }
          // },
          onChange: onChangedRackName,
          onAddItem: (value) {
            if (value == 'Tambah Rak Baru') {
              // Since the onChange is handling the dialog, simply return null here.
              return null;
            }
            return value;
          },
        ),
      ),
    );
  }

  Widget _buildRackLevels({
    required String rackName,
    required BuildContext context,
    required List<String> levels,
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
                  Positioned(
                    right: 5,
                    top: 5,
                    child: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 0) {
                          Get.dialog(
                            AlertDialog(
                              title: Text(
                                'Masukkan Nomor Laci yang baru',
                                style: semiBoldText16,
                              ),
                              content: TextField(
                                controller: controller.customLevelController,
                                style: semiBoldText14,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Ubah Nomor Laci',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    String customLevelName = controller
                                        .customLevelController.text
                                        .trim();

                                    // Assuming you have the current level name stored in a variable `currentLevelName`
                                    controller.onEditLevel(
                                      rackName, // The name of the rack
                                      levels[index], // The current level name
                                      customLevelName, // The new level name
                                    );
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
                        if (value == 1) {
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
                                        levels[index],
                                      ),
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
                              });
                        }
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: kColorScheme.surface,
                      ),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 0,
                            child: Text('Ubah'),
                          ),
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Hapus'),
                          ),
                        ];
                      },
                    ),
                  ),
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
