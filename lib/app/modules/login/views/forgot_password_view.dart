import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/login/controllers/forgot_password_controller.dart';
import 'package:gudang_elektrikal/app/widgets/custom_app_bar.dart';
import 'package:gudang_elektrikal/app/widgets/custom_text_field.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset Kata Sandi',
                style: semiBoldText24,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Email',
                hintText: 'Masukkan email',
                controller: controller.emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  controller.sendPasswordResetLink(
                    email: controller.emailController.value.text,
                  );
                  print('send password tapd');
                },
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
                          'Kirim',
                          style: mediumText18.copyWith(
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ],
          ).marginSymmetric(horizontal: 20),
        );
      },
    );
  }
}