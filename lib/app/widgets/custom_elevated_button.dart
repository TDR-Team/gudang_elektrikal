import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final TextStyle textStyle;
  final ButtonStyle buttonStyle;
  final bool isLoading;
  final Color? progressColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    required this.buttonStyle,
    this.isLoading = false,
    this.progressColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Center(
        child: isLoading
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
                style: textStyle,
              ),
      ),
    );
  }
}
