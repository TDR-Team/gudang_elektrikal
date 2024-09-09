import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/profile/views/edit_profile_view.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          // backgroundColor: kColorScheme.surface,
          // extendBody: true,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'Profil',
              style: semiBoldText20,
            ),
            // surfaceTintColor: Colors.transparent,
            // backgroundColor: Colors.transparent,
          ),
          body: controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: kColorScheme.surface,
                  ),
                )
              : RefreshIndicator(
                  color: kColorScheme.surface,
                  onRefresh: () async {
                    await controller.getUserData();
                  },
                  child: Stack(
                    children: [
                      AppBar(
                        title: Text(
                          'Profil',
                          style: semiBoldText20,
                        ),
                        // surfaceTintColor: Colors.transparent,
                        // backgroundColor: Colors.transparent,
                      ),
                      ListView(
                          physics: const ClampingScrollPhysics(),
                          // shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 150.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: kColorScheme.primary,
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,

                                    child: controller.profileImageUrl == null
                                        ? Text(
                                            controller.name != null &&
                                                    controller.name!.isNotEmpty
                                                ? controller.name![0]
                                                    .toUpperCase()
                                                : 'N', // Default to 'N' if name is empty
                                            style: mediumText48.copyWith(
                                              color: AppColors.primaryColors[0],
                                            ),
                                          )
                                        : null, // If profile image exists, do not show text
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () => Get.to(() =>
                                                    const EditProfileView())!
                                                .then((value) =>
                                                    controller.getUserData()),
                                            child: Text(
                                              'Ubah Profil',
                                              style: regularText12.copyWith(
                                                color: kColorScheme.primary,
                                              ),
                                            ),
                                          )),
                                      Text(
                                        'Nama',
                                        style: regularText12.copyWith(
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),

                                      const SizedBox(height: 5),
                                      Text(
                                        controller.name!,
                                        style: mediumText16,
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Email',
                                        style: regularText12.copyWith(
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.user.email!,
                                        style: mediumText16,
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                        color: Colors.grey.withOpacity(0.3),
                                      ),

                                      // Divider(
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),
                                      const SizedBox(height: 60),
                                      InkWell(
                                        // onTap: () => controller.signOut(),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    kColorScheme.secondary,
                                                title: Text(
                                                  'Konfirmasi',
                                                  style: semiBoldText22,
                                                ),
                                                content: Text(
                                                  'Apakah Anda yakin ingin keluar?',
                                                  style: regularText14,
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Tutup dialog
                                                    },
                                                    child: Text(
                                                      'Tidak',
                                                      style: semiBoldText14,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      controller
                                                          .signOut(); // Panggil fungsi signOut
                                                    },
                                                    child: Text(
                                                      'Ya',
                                                      style: semiBoldText14,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: kColorScheme.primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Keluar',
                                            style: mediumText18.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      InkWell(
                                        // onTap: () => controller.signOut(),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    kColorScheme.secondary,
                                                title: Text(
                                                  'Konfirmasi',
                                                  style: semiBoldText22,
                                                ),
                                                content: Text(
                                                  'Apakah Anda yakin ingin hapus akun?',
                                                  style: regularText14,
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Tutup dialog
                                                    },
                                                    child: Text(
                                                      'Tidak',
                                                      style: semiBoldText14,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      controller
                                                          .deleteAccount(); // Panggil fungsi signOut
                                                    },
                                                    child: Text(
                                                      'Ya',
                                                      style: semiBoldText14,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.red,
                                            ),
                                          ),
                                          child: Text(
                                            'Hapus Akun',
                                            style: mediumText18.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ]),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
