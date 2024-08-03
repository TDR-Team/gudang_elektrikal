import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/modules/activity/views/activity_view.dart';
import 'package:gudang_elektrikal/app/modules/borrow_tools/views/borrow_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/components/views/components_view.dart';
import 'package:gudang_elektrikal/app/modules/login/views/login_view.dart';
import 'package:gudang_elektrikal/app/modules/profile/views/profile_view.dart';
import 'package:gudang_elektrikal/app/widgets/bottom_navigation_bar.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: Center(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                ComponentsView(),
                BorrowToolsView(),
                LoginView(),
                ActivityView(),
                ProfileView()
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            padding: EdgeInsets.zero,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: CustomBottomNavigationBar(
                currentIndex: controller.tabIndex,
                onTap: (index) {
                  if (index != 2) {
                    controller.changeTabIndex(index);
                  }
                },
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            height: 60.h,
            width: 60.h,
            child: FittedBox(
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: kColorScheme.secondary,
                elevation: 0,
                child: Icon(
                  Icons.add_rounded,
                  color: kColorScheme.onSecondary,
                  size: 30.h,
                ),
                onPressed: () {
                  _buildAddComponentsAndTools(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _buildAddComponentsAndTools(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
            ),
          ),
        );
      },
    );
  }
}
