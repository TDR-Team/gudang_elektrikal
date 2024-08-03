import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ubah Profil'),
            centerTitle: true,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.pickImage(),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              backgroundImage: controller.image != null
                                  ? FileImage(controller.image!)
                                  : controller.profileImageUrl != null
                                      ? NetworkImage(
                                              controller.profileImageUrl!)
                                          as ImageProvider
                                      : null,
                              child: (controller.image == null &&
                                      controller.profileImageUrl == null)
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: kColorScheme.surface,
                                    )
                                  : null, // Hanya tampilkan Icon jika tidak ada gambar
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: kColorScheme.secondary,
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: kColorScheme.onSecondary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller.nameController,
                        style: semiBoldText14,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                        ),
                      ),
                      TextField(
                        controller: controller.phoneController,
                        style: semiBoldText14,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Hp',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            kColorScheme.primary,
                          ),
                          foregroundColor: WidgetStatePropertyAll<Color>(
                            kColorScheme.onPrimary,
                          ),
                        ),
                        onPressed: controller.isLoadingSaveEdit
                            ? null
                            : () => controller.saveUserData(),
                        child: controller.isLoadingSaveEdit
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Simpan'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
