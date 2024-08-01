import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/button_styles.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/add_components_controller.dart';
import 'package:gudang_elektrikal/app/widgets/custom_elevated_button.dart';
import 'package:gudang_elektrikal/app/widgets/custom_text_field.dart';
import 'package:gudang_elektrikal/app/widgets/dropdown_button.dart';
import 'package:gudang_elektrikal/app/widgets/show_image_picker_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class AddComponentsView extends GetView<AddComponentsController> {
  const AddComponentsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AddComponentsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Komponen'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildImageProfilePicker(
                  isLoadingImageProfile: controller.isLoadingImageProfile.value,
                  imageProfileFileController:
                      controller.imageProfileFileController.value,
                  networkImageProfile: controller.networkImageProfile.value,
                  onPickImageProfile: controller.onPickImageProfile,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Nama Komponen',
                  controller: controller.nameComponent,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Deskripsi',
                  controller: controller.descriptionComponent,
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
                        'Stock',
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
                        'Unit',
                        style: semiBoldText16,
                      ),
                    ),
                    _buildDropDown(
                      context: context,
                      listRack: controller.listUnit,
                      rackName: controller.unitName.value,
                      onChangedRackName: controller.onChangedRackName,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.h,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 25,
        ),
        child: CustomElevatedButton(
          onPressed: () {
            Get.back();
            Get.showSnackbar(
              GetSnackBar(
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.zero,
                borderRadius: 10,
                messageText: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.check,
                          color: kColorScheme.surface,
                          size: 24.sp,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Berhasil',
                              style: boldText18,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              'Komponen berhasil di tambahkan',
                              style: regularText14,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                duration: const Duration(seconds: 3),
                barBlur: 2,
                backgroundColor: Colors.grey[200]!.withOpacity(0.4),
                snackStyle: SnackStyle.FLOATING,
              ),
            );
          },
          text: 'Tambah',
          buttonStyle: primary300Button.copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.only(left: 16),
            ),
          ),
          // buttonStyle: primary300Button,
        ),
      ),
    );
  }

  _buildDropDown({
    required BuildContext context,
    required List<String> listRack,
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

  _buildImageProfilePicker({
    required bool isLoadingImageProfile,
    File? imageProfileFileController,
    String? networkImageProfile,
    required Future Function({required bool isCamera}) onPickImageProfile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showImagePickerBottomSheet(
              onPickImage: onPickImageProfile,
            );
          },
          borderRadius: BorderRadius.circular(120),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              children: [
                isLoadingImageProfile
                    ? Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 148, 148, 148),
                        highlightColor: const Color.fromARGB(255, 102, 95, 95),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          120,
                        ),
                        child: networkImageProfile != null &&
                                networkImageProfile != ''
                            ? Image.network(
                                networkImageProfile,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          255, 148, 148, 148),
                                      highlightColor: const Color.fromARGB(
                                          255, 102, 95, 95),
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    width: 120,
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
                            : imageProfileFileController != null
                                ? Image.file(
                                    File(
                                      imageProfileFileController.path,
                                    ),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset(
                                    'assets/images/default_profile_image.svg',
                                  ),
                      ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.add,
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
