import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';
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
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/img_auth.png',
                        fit: BoxFit.fitHeight,
                        height: 180.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.grey,
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 75,
                              color: Color.fromARGB(255, 53, 53, 53),
                            ),
                          );
                        },
                      ),
                    ).marginOnly(bottom: 10),
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
                      onPressedIconPassword: () {
                        controller.onPressedIconPassword(isPassword: true);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Konfirmasi Kata Sandi',
                      hintText: 'Masukkan ulang kata sandi',
                      controller: controller.confirmPasswordController,
                      isPassword: true,
                      isPasswordHide: controller.isConfirmPasswordHide,
                      onPressedIconPassword: () {
                        controller.onPressedIconPassword(isPassword: false);
                      },
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () => controller.register(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  color: kColorScheme.primary,
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
                TextButton(
                  onPressed: () => Get.offAllNamed(Routes.LOGIN),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.all(4),
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(50, 25)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Masuk',
                    style: boldText12.copyWith(
                      color: Colors.amber,
                    ),
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
