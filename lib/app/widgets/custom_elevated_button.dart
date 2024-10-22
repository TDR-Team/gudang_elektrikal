import 'package:flutter/material.dart';

import '../common/styles/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final ButtonStyle buttonStyle;
  final bool isLoading;
  final Color? progressColor;
  final Widget? icon;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    required this.buttonStyle,
    this.isLoading = false,
    this.progressColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: buttonStyle,
      icon: icon,
      label: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: progressColor,
              ),
            )
          : Text(
              text,
              style: textStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.neutralColors[5],
                  ),
            ),
    );
  }
}
