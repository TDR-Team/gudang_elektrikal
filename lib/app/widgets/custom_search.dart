import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

class CustomSearch extends StatelessWidget {
  final TextEditingController searchController;
  final void Function()? onTap;
  const CustomSearch({
    super.key,
    required this.searchController,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      autofocus: false,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      onTap: onTap,
      child: TextField(
        autofocus: false,
        autocorrect: false,
        controller: searchController,
        cursorColor: AppColors.primaryColors[1],
        style: regularText14,
        decoration: InputDecoration(
          fillColor: kColorScheme.onSecondary,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintText: 'Cari...',
          hintStyle: regularText16.copyWith(
            color: Colors.grey,
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(15),
            width: 18,
            child: SvgPicture.asset(
              'assets/icons/ic_search.svg',
              // colorFilter: const ColorFilter.mode(
              //   Colors.grey,
              //   BlendMode.srcIn,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
