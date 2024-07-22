import 'package:flutter/material.dart';
import '../common/theme/font.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    this.isEnabled = true,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.isPasswordHide = false,
    this.isRequired = true,
    required this.controller,
    this.onPressedIconPassword,
    this.isAutoValidate = true,
    this.inputAction,
    this.validator,
    this.onCompleted,
    this.isPasswordEmpty = false,
  });

  final String label;
  final bool isRequired;
  final TextStyle? labelStyle;
  final bool isEnabled;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final Function()? onTap;
  final TextInputType textInputType;
  final bool isPassword;
  final bool isPasswordHide;
  final TextEditingController controller;
  final void Function()? onPressedIconPassword;
  final bool isAutoValidate;
  final TextInputAction? inputAction;
  final String? Function(String?)? validator; // Perubahan tipe data di sini
  final VoidCallback? onCompleted; // Perubahan tipe data di sini
  final bool isPasswordEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            style: semiBoldText20,
            children: [
              TextSpan(
                text: label,
                style: labelStyle,
              ),
              const WidgetSpan(
                child: SizedBox(
                  width: 4,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: '*',
                  style: semiBoldText14.copyWith(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          validator: validator,
          enabled: isEnabled,
          obscureText: isPasswordHide,
          controller: controller,
          style: const TextStyle(
            fontSize: 12,
          ),
          keyboardType: textInputType,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              // borderSide: BorderSide.,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            // fillColor: Colors.grey[200],
            fillColor: Colors.transparent,
            filled: true,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordHide ? Icons.visibility_off : Icons.visibility,
                    ),
                    color: Colors.black,
                    onPressed:
                        onPressedIconPassword, // Memastikan fungsi tidak null sebelum digunakan
                  )
                : null,
          ),
          onEditingComplete: onCompleted,
          readOnly: onTap != null,
          onTap: onTap,
          textInputAction: inputAction,
          autovalidateMode:
              isAutoValidate ? AutovalidateMode.onUserInteraction : null,
        ),
      ],
    );
  }
}
