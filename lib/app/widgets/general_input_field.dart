import 'package:flutter/material.dart';
import '../common/theme/font.dart';

class GeneralInputField extends StatelessWidget {
  final String hintText;
  final String label;

  const GeneralInputField({
    super.key,
    required this.hintText,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: semiBoldText16,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          style: mediumText12,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(242, 242, 242, 1.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(178, 178, 178, 1.0),
            ),
          ),
        )
      ],
    );
  }
}
