import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/history/views/history_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/tools_view.dart';
import 'package:gudang_elektrikal/app/modules/components/views/components_view.dart';
import 'package:gudang_elektrikal/app/modules/login/views/login_view.dart';
import 'package:gudang_elektrikal/app/modules/profile/views/profile_view.dart';
import 'package:gudang_elektrikal/app/routes/app_pages.dart';
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
          // extendBodyBehindAppBar: true,
          body: Center(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                ComponentsView(),
                ToolsView(),
                LoginView(),
                HistoryView(),
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
          // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
            child: SizedBox(
              height: 60.h,
              width: 60.h,
              child: FittedBox(
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.amber,
                  elevation: 0,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/img_logoApp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  onPressed: () {
                    _buildAddComponentsAndTools(context);
                  },
                ),
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
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                // vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.sizeOf(context).width / 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: kColorScheme.primary,
                    onTap: () {
                      Get.toNamed(Routes.GET_COMPONENTS);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: kColorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: kColorScheme.primary,
                            minRadius: 24.sp,
                            child: Icon(
                              Icons.all_inbox,
                              size: 24.sp,
                              color: kColorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Ambil Komponen',
                            style: semiBoldText18.copyWith(
                              color: kColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: kColorScheme.primary,
                    onTap: () {
                      Get.toNamed(Routes.BORROW_TOOLS);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: kColorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: kColorScheme.primary,
                            minRadius: 24.sp,
                            child: Icon(
                              Icons.build_outlined,
                              size: 24.sp,
                              color: kColorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Pinjam Alat',
                            style: semiBoldText18.copyWith(
                              color: kColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
