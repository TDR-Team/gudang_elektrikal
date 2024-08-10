import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/widgets/custom_search.dart';

import '../../../common/theme/font.dart';
import '../controllers/borrow_tools_controller.dart';

class BorrowToolsView extends GetView<BorrowToolsController> {
  const BorrowToolsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BorrowToolsController());
    return Scaffold(
      backgroundColor: kColorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Pinjam Alat',
          style: semiBoldText20,
        ),
        surfaceTintColor: Colors.transparent,
        // backgroundColor: kColorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150.h,
            child: Stack(
              children: [
                Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kColorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/img_bgTools.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned(
                //   left: 0,
                //   right: MediaQuery.sizeOf(context).width / 4,
                //   bottom: 0,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     child: CustomSearch(
                //       searchController: controller.searchController,
                //       //                       onTap: () {
                //       //                         FocusScope.of(context).unfocus();

                //       // // This is the correct approach of calling unfocus on primary focus
                //       //                         FocusManager.instance.primaryFocus!.unfocus();
                //       //                         TextEditingController().clear();
                //       //                       },
                //     ),
                //   ),
                // ),
                // Positioned(
                //   left: MediaQuery.sizeOf(context).width / 1.4,
                //   right: 0,
                //   bottom: 0,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     child: Container(
                //       padding: const EdgeInsets.all(20),
                //       color: Colors.amber,
                //     ),
                //   ),
                // )
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: CustomSearch(
                            searchController: controller.searchController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          // width: ,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            size: 24.sp,
                          ),
                        ),
                        // Flexible(
                        //   flex: 1,
                        //   child: CustomSearch(
                        //     searchController: controller.searchController,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // Expanded(
          //   child: Obx(
          //     () {
          //       // return _buildRackContent(
          //       //   context: context,
          //       //   rackName: controller.rackNames,
          //       //   onDrawerClicked: controller.onDrawerClicked,
          //       // );
          //       // return _buildRackContent(
          //       //   context: context,
          //       //   rackName: controller.rackName.value,
          //       //   drawers: controller.listDrawers,
          //       //   onDrawerClicked: controller.onDrawerClicked,
          //       // );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  // _buildDropDown({
  //   required List<String> listRack,
  //   // required String rackName,
  //   required void Function(String? value) onChangedRackName,
  // }) {
  //   return Positioned(
  //     left: 0,
  //     right: 0,
  //     bottom: 0,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       child: DropDown(
  //         listElement: listRack,
  //         hintText: 'Rak 1',
  //         // selectedItem: rackName,
  //         onChange: onChangedRackName,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildRackContent({
    required String rackName,
    required BuildContext context,
    required List<String> drawers,
    required void Function(String rackName, String drawerName) onDrawerClicked,
  }) {
    // return ListView.builder(
    //   itemCount: drawers.length,
    //   itemBuilder: (context, index) {
    //     final drawer = drawers[index];
    //     return GestureDetector(
    //       onTap: () => onDrawerClicked(rackName, drawer.id),
    //       child: Card(
    //         child: ListTile(
    //           title: Text(drawer.name),
    //           subtitle: Text(drawer.description),
    //           trailing: Text('${drawer.stock} ${drawer.unit}'),
    //         ),
    //       ),
    //     );
    //   },
    // );
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        top: 12,
        right: 0,
        left: 0,
        bottom: 50,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          // onTap: onDrawerClicked,
          onTap: () {
            // Get.to(
            //   () => const ListComponentsView(),
            //   arguments: {
            //     "numberDrawer": listDummyComponents[index].numberDrawer,
            //   },
            // );
          },
          child: UnconstrainedBox(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width / 2,
              decoration: BoxDecoration(
                color: kColorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                // listDummyComponents[index].numberDrawer.toString(),
                drawers[index],
                style: boldText28.copyWith(
                  color: Colors.white,
                  fontSize: 96.sp,
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: drawers.length,
    );
    //   // switch (rackName) {
    //   //   case 'rack_1':
    //   //     return _buildContentForRack1(onDrawerClicked: onDrawerClicked);
    //   //   case 'rack_2':
    //   //     return _buildContentForRack2();
    //   //   default:
    //   //     return const SizedBox.shrink();
    //   // }
    // }
  }
}
