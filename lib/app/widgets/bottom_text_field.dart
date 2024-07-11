import 'package:flutter/material.dart';
import '../common/theme/font.dart';


class BottomTextField extends StatelessWidget {
  final String title;
  final bool isForgotPassword;
  final void Function()? onTap;
  const BottomTextField({
    super.key,
    this.isForgotPassword = false,
    this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Min. 8 characters",
          style: regularText12,
        ),
        const Spacer(),
        isForgotPassword
            ? InkWell(
                onTap: onTap,
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: regularText14.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
