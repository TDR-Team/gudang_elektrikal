import 'package:flutter/material.dart';
import '../common/theme/font.dart';

class PasswordInputField extends StatefulWidget {
  final String hintText, label;
  const PasswordInputField({
    super.key,
    required this.hintText,
    required this.label,
  });

  @override
  State<PasswordInputField> createState() => _PasswordVisibleState();
}

class _PasswordVisibleState extends State<PasswordInputField> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: semiBoldText16,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: passwordVisible,
          style: regularText16,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(242, 242, 242, 1.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            hintText: widget.hintText,
            hintStyle: mediumText12.copyWith(
              color: const Color.fromRGBO(178, 178, 178, 1.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color.fromRGBO(178, 178, 178, 1.0),
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
