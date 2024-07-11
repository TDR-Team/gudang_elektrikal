import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/register/views/register_view.dart';
import 'package:gudang_elektrikal/app/widgets/custom_text_field.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
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
                    // color: Colors.amber,
                    width: double.infinity,
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/images/img_login.svg',
                        // color: Colors.blue,
                        semanticsLabel: 'My SVG Picture',
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    'Selamat Datang!',
                    style: semiBoldText24,
                  ),
                  const SizedBox(height: 25),
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
                    // validator: validatorPassword,
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () => controller.onLoginClicked(),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kColorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 3,
                              ),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Masuk',
                              style: mediumText18.copyWith(
                                color: Colors.black,
                              ),
                            ),
                    ),
                  )
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
                  'Belum punya akun?',
                  style: regularText12,
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => Get.offAll(() => const RegisterView()),
                  child: Text(
                    'Daftar',
                    style: boldText12.copyWith(
                      color: kColorScheme.secondary,
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
