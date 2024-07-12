import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

import '../controllers/list_drawer_controller.dart';

class ListDrawerView extends GetView<ListDrawerController> {
  const ListDrawerView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ListDrawerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 207,
              child: Stack(
                children: [
                  Container(
                    height: 187,
                    decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                  ),
                  // _buildDropDown(
                  //   listRack: controller.listRack,
                  //   rackName: controller.rackName.value,
                  //   onChangedRackName: controller.onChangedRackName,
                  // ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      // onTap: () {
                      //   Get.to(()=> ListJobPage());
                      // },
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Theme(
                          data: ThemeData(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: TextField(
                            
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(
                              //     width: 1,
                              //     color: AppColors.neutralColors[2],
                              //   ),
                              //   borderRadius: const BorderRadius.all(
                              //     Radius.circular(50),
                              //   ),
                              // ),
                              
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              // enabled: false,
                              hintText: 'Search',
                              
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(15),
                                width: 18,
                                child: SvgPicture.asset(
                                    'assets/icons/ic_search.svg'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Obx(
            //   () {
            //     return _buildRackContent(
            //       context: context,
            //       rackName: controller.rackName.value,
            //       onDrawerClicked: controller.onDrawerClicked,
            //     );
            //   },
            // ),
          ],
        ),
        // Widget yang berubah sesuai dengan pilihan rak
      ),
    );
  }
}
