import 'package:flutter/material.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? action;
  final double height;
  final void Function()? onTap;
  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
    this.height = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: kColorScheme.background,
      elevation: 0,
      leading: IconButton(
        onPressed: onTap ?? () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: kColorScheme.primary,
          size: 24,
        ),
      ),
      centerTitle: true,
      title: Text(
        title!,
        style: semiBoldText18.copyWith(
          color: kColorScheme.primary,
        ),
      ),
      actions: action,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
