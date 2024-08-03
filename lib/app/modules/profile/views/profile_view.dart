import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/profile/views/edit_profile_view.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(ProfileController());
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightBlue,
                  ),
                )
              : RefreshIndicator(
                  color: Colors.lightBlue,
                  onRefresh: () async {
                    await controller.getUserData();
                  },
                  child: ListView(
                      physics: const ClampingScrollPhysics(),
                      // shrinkWrap: true,
                      children: [
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 150,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                              ),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: ClipOval(
                                  child: controller.profileImageUrl != null
                                      ? Image.network(
                                          controller.profileImageUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Shimmer.fromColors(
                                                baseColor: const Color.fromARGB(
                                                    255, 148, 148, 148),
                                                highlightColor:
                                                    const Color.fromARGB(
                                                        255, 102, 95, 95),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: Colors.grey,
                                              ),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Color.fromARGB(
                                                    255, 53, 53, 53),
                                              ),
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () => Get.to(
                                                () => const EditProfileView())!
                                            .then((value) =>
                                                controller.getUserData()),
                                        child: Text(
                                          'Ubah Profil',
                                          style: regularText12.copyWith(
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                      )),
                                  Text(
                                    'Nama Lengkap',
                                    style: regularText12.copyWith(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 16,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      controller.name!,
                                      style: mediumText16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Divider(
                              thickness: 10,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  const SizedBox(height: 10),
                                  Text(
                                    'Nomor Hp',
                                    style: regularText12.copyWith(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    controller.phone != null
                                        ? '0${controller.phone.toString()}'
                                        : 'Belum mengisi Nomor HP',
                                    // 'Belum mengisi Nomor Hp',
                                    style: mediumText16,
                                  ),
                                  const SizedBox(height: 10),
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
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin keluar?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Tutup dialog
                                                },
                                                child: const Text('Tidak'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller
                                                      .signOut(); // Panggil fungsi signOut
                                                },
                                                child: const Text('Ya'),
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
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.circular(10),
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
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin hapus akun?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Tutup dialog
                                                },
                                                child: const Text('Tidak'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller
                                                      .deleteAccount(); // Panggil fungsi signOut
                                                },
                                                child: const Text('Ya'),
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
                                        borderRadius: BorderRadius.circular(10),
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
                ),
        );
      },
    );
  }
}
