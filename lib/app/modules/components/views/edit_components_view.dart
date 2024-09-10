import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/button_styles.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/widgets/custom_elevated_button.dart';
import 'package:gudang_elektrikal/app/widgets/custom_text_field.dart';
import 'package:gudang_elektrikal/app/widgets/dropdown_button.dart';
import 'package:gudang_elektrikal/app/widgets/show_image_picker_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/edit_components_controller.dart';

class EditComponentsView extends GetView<EditComponentsController> {
  const EditComponentsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EditComponentsController());

    final controller = Get.find<EditComponentsController>();
    controller.setRackAndLevel(); // Set the rack and level

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            padding: const EdgeInsets.all(16),
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24.sp,
              color: Colors.black,
            ),
          ),
          title: const Text('Ubah Komponen'),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => _buildImagePicker(
                      isLoadingImage: controller.isLoadingImage.value,
                      imageFileController: controller.imageFileController.value,
                      networkImage: controller.networkImage.value,
                      onPickImage: controller.onPickImage,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Nama Komponen',
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Deskripsi',
                    controller: controller.descriptionController,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 100,
                    isRequired: false,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Stok',
                          style: semiBoldText16,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kColorScheme.primary,
                            // color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: controller.decrement,
                                icon: Icon(
                                  Icons.remove,
                                  color: kColorScheme.surface,
                                  size: 24.sp,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                ),
                                width: 50.w,
                                child: CustomTextField(
                                  label: '',
                                  controller: controller.stockController,
                                  textAlign: TextAlign.center,
                                  lengthInput: 3,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  textInputType: TextInputType.number,
                                  focusNode: controller.stockFocusNode,
                                  textStyle: semiBoldText16,
                                ),
                              ),
                              IconButton(
                                onPressed: controller.increment,
                                icon: Icon(
                                  Icons.add,
                                  color: kColorScheme.surface,
                                  size: 24.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Satuan',
                          style: semiBoldText16,
                        ),
                      ),
                      _buildDropDown(
                        context: context,
                        listRack: controller.listUnit,
                        rackName: controller.unitName.value,
                        onChangedRackName: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.onChangedRackName(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            height: 50.h,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 25,
            ),
            child: CustomElevatedButton(
              isLoading: controller.isLoadingAddComponent.value,
              onPressed: () async {
                await controller.onEditComponentClicked();
              },
              text: 'Simpan',
              buttonStyle: primary300Button.copyWith(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.only(left: 16),
                ),
                overlayColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 13, 97, 128),
                ),
              ),
              // buttonStyle: primary300Button,
            ),
          ),
        ),
      ),
    );
  }

  _buildDropDown({
    required BuildContext context,
    required var listRack,
    required String rackName,
    required void Function(String? value) onChangedRackName,
  }) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: DropDown(
          showSearchBox: false,
          listElement: listRack,
          selectedItem: rackName,
          onChange: onChangedRackName,
          borderSide: const BorderSide(),
          fillColor: Colors.white,
        ),
      ),
    );
  }

  _buildImagePicker({
    required bool isLoadingImage,
    File? imageFileController,
    String? networkImage,
    required Future Function({required bool isCamera}) onPickImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showImagePickerBottomSheet(
              onPickImage: onPickImage,
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 150.h,
            height: 150.h,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: networkImage != null && networkImage != ''
                      ? Image.network(
                          networkImage,
                          width: 150.h,
                          height: 150.h,
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
                                  width: 150.h,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.circular(10),

                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150.h,
                              width: 150.h,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 90,
                                  color: Color.fromARGB(255, 53, 53, 53),
                                ),
                              ),
                            );
                          },
                        )
                      : imageFileController != null
                          ? Image.file(
                              File(
                                imageFileController.path,
                              ),
                              width: 150.h,
                              height: 150.h,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 150.h,
                              height: 150.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 60.sp,
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
