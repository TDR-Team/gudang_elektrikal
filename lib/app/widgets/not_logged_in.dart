import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';


class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/OB4.svg',
          height: 330,
          width: 326,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Text(
                "Silahkan masuk terlebih dahulu.",
                textAlign: TextAlign.center,
                style: boldText16.copyWith(
                  color: kColorScheme.primary,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Masuk',
                  style:
                      boldUnderlineText16.copyWith(color: kColorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.back();
                      // Get.to(const LoginPage());
                    },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
