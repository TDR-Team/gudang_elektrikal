import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedLabelStyle: semiBoldText12,
      backgroundColor: kColorScheme.primary,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: kColorScheme.secondary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.all_inbox,
            size: 24.h,
          ),
          activeIcon: Icon(
            Icons.all_inbox,
            size: 24.h,
            color: kColorScheme.surface,
          ),
          label: 'Komponen',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.build_outlined,
            size: 24.h,
          ),
          activeIcon: Icon(
            Icons.build_outlined,
            size: 24.h,
            color: kColorScheme.surface,
          ),
          label: 'Alat',
        ),
        BottomNavigationBarItem(
          icon: Visibility(
            visible: false,
            child: Icon(
              Icons.chat_rounded,
              size: 24.h,
            ),
          ),
          activeIcon: Visibility(
            visible: false,
            child: Icon(
              Icons.chat_rounded,
              size: 24.h,
              color: kColorScheme.surface,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.history,
            size: 24.h,
          ),
          activeIcon: Icon(
            Icons.history,
            size: 24.h,
            color: kColorScheme.surface,
          ),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: 24.h,
          ),
          activeIcon: Icon(
            Icons.person_outline,
            size: 24.h,
            color: kColorScheme.surface,
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
