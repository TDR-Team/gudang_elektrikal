import 'package:flutter/material.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';



class TextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String? value)? onChange;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSave;
  final bool readOnly;
  final void Function()? onTap;
  final String? suffixText;
  final Widget? suffixIcon;

  const TextForm({
    super.key,
    this.onChange,
    this.controller,
    required this.hintText,
    this.validator,
    this.onSave,
    this.readOnly = false,
    this.onTap,
    this.suffixText,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: regularText12,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        suffixText: suffixText,
        hintText: hintText,
        filled: true,
        fillColor: AppColors.neutralColors[4],
        suffixIcon:suffixIcon,
        suffixIconColor: AppColors.neutralColors[2],
      ),
      onChanged: onChange,
      validator: validator,
      onSaved: onSave,
      onTap: onTap,
      readOnly: readOnly,
    );
  }
}
