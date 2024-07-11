import 'package:flutter/material.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';



class TitleDate extends StatelessWidget {
  final String date;
  const TitleDate({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: boldText14.copyWith(
        color: AppColors.primaryColors[0],
      ),
    );
  }
}
