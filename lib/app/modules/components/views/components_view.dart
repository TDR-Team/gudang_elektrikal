import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/data/model/component.dart';
import 'package:gudang_elektrikal/app/modules/components/views/list_components_view.dart';
import 'package:gudang_elektrikal/app/widgets/dropdown_button.dart';

import '../controllers/components_controller.dart';

class ComponentsView extends GetView<ComponentsController> {
  const ComponentsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ComponentsController());
    return Scaffold(
      backgroundColor: kColorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Ambil Komponen',
          style: semiBoldText20,
        ),
        surfaceTintColor: Colors.transparent,
        // backgroundColor: kColorScheme.primary,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                size: 24.sp,
                color: Colors.black,
              ),
            ),
          )
        ],
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
                        'assets/images/img_bgAppbar.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _buildDropDown(
                  listRack: controller.rackNames,
                  // rackName: controller.rackName.value,
                  onChangedRackName: controller.onChangedRackName,
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                // return _buildRackContent(
                //   context: context,
                //   rackName: controller.rackNames,
                //   onDrawerClicked: controller.onDrawerClicked,
                // );
                return _buildRackContent(
                  context: context,
                  rackName: controller.rackName.value,
                  drawers: controller.listDrawers,
                  onDrawerClicked: controller.onDrawerClicked,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildDropDown({
    required List<String> listRack,
    // required String rackName,
    required void Function(String? value) onChangedRackName,
  }) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropDown(
          listElement: listRack,
          hintText: 'Rak 1',
          // selectedItem: rackName,
          onChange: onChangedRackName,
        ),
      ),
    );
  }

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
            Get.to(
              () => const ListComponentsView(),
              arguments: {
                "numberDrawer": listDummyComponents[index].numberDrawer,
              },
            );
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

  // Fungsi untuk menampilkan konten berdasarkan rak yang dipilih
  // Widget _buildRackContent({
  //   List<String>? rackName,
  //   BuildContext? context,
  //   required void Function() onDrawerClicked,
  // }) {
  //   return Expanded(
  //     child: ListView.separated(
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.only(
  //         top: 12,
  //         right: 0,
  //         left: 0,
  //         bottom: 0,
  //       ),
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           // onTap: onDrawerClicked,
  //           onTap: () {
  //             Get.to(
  //               () => const ListComponentsView(),
  //               arguments: {
  //                 "numberDrawer": listDummyComponents[index].numberDrawer,
  //               },
  //             );
  //           },
  //           child: UnconstrainedBox(
  //             child: Container(
  //               alignment: Alignment.center,
  //               width: MediaQuery.sizeOf(context).width / 2,
  //               decoration: BoxDecoration(
  //                 color: kColorScheme.primary,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Text(
  //                 listDummyComponents[index].numberDrawer.toString(),
  //                 style: boldText28.copyWith(
  //                   color: Colors.white,
  //                   fontSize: 96.sp,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       separatorBuilder: (context, index) => const SizedBox(height: 20),
  //       itemCount: rackName!.length,
  //     ),
  //   );
  //   // switch (rackName) {
  //   //   case 'rack_1':
  //   //     return _buildContentForRack1(onDrawerClicked: onDrawerClicked);
  //   //   case 'rack_2':
  //   //     return _buildContentForRack2();
  //   //   default:
  //   //     return const SizedBox.shrink();
  //   // }
  // }

  // Contoh widget konten untuk Rak 1
  Widget _buildContentForRack1({
    required void Function() onDrawerClicked,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        top: 12,
        right: 0,
        left: 0,
        bottom: 0,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          // onTap: onDrawerClicked,
          onTap: () {
            Get.to(
              () => const ListComponentsView(),
              arguments: {
                "numberDrawer": listDummyComponents[index].numberDrawer,
              },
            );
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
                listDummyComponents[index].numberDrawer.toString(),
                style: boldText28.copyWith(
                  color: Colors.white,
                  fontSize: 96.sp,
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: listDummyComponents.length,
    );
  }

  // Contoh widget konten untuk Rak 2
  Widget _buildContentForRack2() {
    return const Positioned(
      top: 100, // Sesuaikan posisi konten
      left: 0,
      right: 0,
      child: Text(
        'Konten untuk Rak 2',
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gudang_elektrikal/app/common/styles/colors.dart';
// import 'package:gudang_elektrikal/app/common/theme/font.dart';
// import 'package:gudang_elektrikal/app/data/model/component.dart';
// import 'package:gudang_elektrikal/app/modules/components/views/list_components_view.dart';
// import 'package:gudang_elektrikal/app/widgets/dropdown_button.dart';

// import '../controllers/components_controller.dart';

// class ComponentsView extends GetView<ComponentsController> {
//   const ComponentsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => ComponentsController());
//     return Scaffold(
//       backgroundColor: kColorScheme.surface,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(
//           'Ambil Komponen',
//           style: semiBoldText20,
//         ),
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 150.h,
//             child: Stack(
//               children: [
//                 Container(
//                   height: 130.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: kColorScheme.primary,
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(30),
//                     ),
//                     image: const DecorationImage(
//                       image: AssetImage('assets/images/img_bgAppbar.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Obx(
//                       () => DropDown(
//                         listElement: controller.rackNames,
//                         hintText: 'Pilih Rak',
//                         selectedItem: '',
//                         onChange: controller.onChangedRackName,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Obx(
//               () {
//                 return _buildRackContent(
//                   context: context,
//                   rackName: controller.rackName.value,
//                   drawers: controller.drawers[controller.rackName.value] ?? [],
//                   onDrawerClicked: controller.onDrawerClicked,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRackContent({
//     required String rackName,
//     required BuildContext context,
//     required List<Component> drawers,
//     required void Function(String rackName, String drawerName) onDrawerClicked,
//   }) {
//     return ListView.builder(
//       itemCount: drawers.length,
//       itemBuilder: (context, index) {
//         final drawer = drawers[index];
//         return GestureDetector(
//           onTap: () => onDrawerClicked(rackName, drawer.id),
//           child: Card(
//             child: ListTile(
//               title: Text(drawer.name),
//               subtitle: Text(drawer.description),
//               trailing: Text('${drawer.stock} ${drawer.unit}'),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
