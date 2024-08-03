import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarView extends GetView<BottomNavBarController> {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => controller.pages[controller.currentIndex.value],
      ),
      extendBody: true,
      bottomNavigationBar: Obx(
        () => CustomBottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(50),
      //   ),
      //   backgroundColor: kColorScheme.secondary,
      //   elevation: 0,
      //   child: Icon(
      //     Icons.add_rounded,
      //     color: kColorScheme.onSecondary,
      //     size: 40,
      //   ),
      //   onPressed: () {
      //     _buildAddComponentsAndTools(context);
      //   },
      // ),
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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Theme(
        data: ThemeData(
          useMaterial3: false,
        ),
        child: BottomAppBar(
          elevation: 1,
          height: 50.h,
          color: kColorScheme.primary,
          shape: const CircularNotchedRectangle(),
          notchMargin: 3.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => onTap(0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.all_inbox),
                        SvgPicture.asset(
                          "assets/ic_getComponents.svg",
                          width: 34.h,
                          height: 34.h,
                          colorFilter: ColorFilter.mode(
                            currentIndex == 0 ? Colors.black : Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Ambil Komponen ',
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: currentIndex == 0
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => onTap(1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_borrowTools.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            currentIndex == 1 ? Colors.black : Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Pinjam Alat',
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: currentIndex == 1
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 44),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => onTap(2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_activity.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            currentIndex == 2 ? Colors.black : Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Aktivitas',
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: currentIndex == 2
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => onTap(3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_profile.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            currentIndex == 3 ? Colors.black : Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Profil',
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: currentIndex == 3
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
