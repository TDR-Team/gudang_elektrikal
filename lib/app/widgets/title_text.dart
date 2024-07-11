import 'package:flutter/material.dart';
import '../common/theme/font.dart';

class TitleText extends StatelessWidget {
  final String title;
  final TextOverflow? overflow;
  final Color color;
  final TextStyle? textStyle;
  final int? maxLines;
  const TitleText({
    super.key,
    required this.title,
    this.color = Colors.black,
    this.textStyle,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStyle ?? mediumText14,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
