import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/login/views/login_view.dart';
import 'package:gudang_elektrikal/app/widgets/custom_text_field.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/img_register.svg', // Change this to your register SVG asset
                      semanticsLabel: 'Register SVG Picture',
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    'Buat akun anda',
                    style: semiBoldText24,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    label: 'Nama Lengkap',
                    hintText: 'Masukkan nama',
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Masukkan email',
                    controller: controller.emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi',
                    controller: controller.passwordController,
                    isPassword: true,
                    isPasswordHide: controller.isPasswordHide,
                    onPressedIconPassword: controller.onPressedIconPassword,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Konfirmasi Kata Sandi',
                    hintText: 'Masukkan ulang kata sandi',
                    controller: controller.confirmPasswordController,
                    isPassword: true,
                    isPasswordHide: controller.isPasswordHide,
                    onPressedIconPassword: controller.onPressedIconPassword,
                  ),
                  const SizedBox(height: 75),
                  InkWell(
                    onTap: () => controller.register(),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kColorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.isLoading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                              ),
                              child: CircularProgressIndicator(
                                color: kColorScheme.secondary,
                              ),
                            )
                          : Text(
                              'Daftar',
                              style: mediumText18.copyWith(
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun?',
                  style: regularText12,
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => Get.offAll(() => const LoginView()),
                  child: Text(
                    'Masuk',
                    style: boldText12.copyWith(color: kColorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
