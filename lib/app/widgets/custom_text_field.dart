import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/theme/font.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
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
  final EdgeInsetsGeometry? contentPadding;
  final int? lengthInput;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final TextStyle? textStyle;

  const CustomTextField({
    super.key,
    this.label,
    this.labelStyle,
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
    this.contentPadding,
    this.lengthInput,
    this.textAlign = TextAlign.left,
    this.focusNode,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Visibility(
          visible: label != '',
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: semiBoldText20,
              children: [
                TextSpan(
                  text: label,
                  style: labelStyle ??
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
        ),
        const SizedBox(height: 4),
        TextFormField(
          autocorrect: false,
          inputFormatters: [LengthLimitingTextInputFormatter(lengthInput)],
          validator: validator,
          enabled: isEnabled,
          obscureText: isPasswordHide,
          controller: controller,
          style: textStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
              ),
          keyboardType: textInputType,
          maxLines: maxLines,
          maxLength: maxLength,
          textAlign: textAlign!,
          focusNode: focusNode,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
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
            contentPadding: contentPadding ?? const EdgeInsets.all(12.0),
            // fillColor: Colors.grey[200],
            fillColor: Colors.white,
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
