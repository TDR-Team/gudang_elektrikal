import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/register/views/register_view.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';
import 'package:gudang_elektrikal/app/widgets/custom_text_field.dart';

import '../../../widgets/custom_elevated_button.dart';
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
            child: Column(
              children: [
                // Stack(
                //   clipBehavior: Clip.none,
                //   alignment: Alignment.center,
                //   children: [
                //     Container(
                //       height: 200.h,
                //       decoration: BoxDecoration(
                //         color: AppColors.primaryColors[0],
                //         borderRadius: const BorderRadius.only(
                //           bottomRight: Radius.circular(50),
                //         ),
                //       ),
                //     ),
                //     Image.asset(
                //       'assets/images/img_pln.png',
                //       fit: BoxFit.cover,
                //     ).marginAll(20),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 70),
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
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.FORGOT_PASSWORD);
                          },
                          child: Text(
                            'Lupa password?',
                            style: mediumText12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => controller.signIn(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.neutralColors[3],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'atau Masuk dengan',
                              style: regularText10,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.neutralColors[3],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          onPressed: () {
                            controller.signInWithGoogle();
                          },
                          text: 'dengan Google',
                          textStyle: mediumText14,
                          buttonStyle: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(0),
                            shadowColor: const WidgetStatePropertyAll(
                                Colors.transparent),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            backgroundColor: const WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: AppColors.neutralColors[3],
                                ),
                              ),
                            ),
                          ),
                          icon: SvgPicture.asset('assets/icons/ic_google.svg'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
