import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/data/model/component.dart';
import 'package:gudang_elektrikal/app/modules/list_drawer/views/list_drawer_view.dart';
import 'package:gudang_elektrikal/app/widgets/dropdown_button.dart';
import '../controllers/get_components_controller.dart';

class GetComponentsView extends GetView<GetComponentsController> {
  const GetComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => GetComponentsController());
    return const Scaffold(
  //     backgroundColor: kColorScheme.surface,
  //     extendBodyBehindAppBar: true,
  //     appBar: AppBar(
  //       title: Text(
  //         'Ambil Komponen',
  //         style: semiBoldText20,
  //       ),
  //       surfaceTintColor: Colors.transparent,
  //       // backgroundColor: kColorScheme.primary,
  //       backgroundColor: Colors.transparent,
  //     ),
  //     body: Column(
  //       children: [
  //         SizedBox(
  //           height: 150.h,
  //           child: Stack(
  //             children: [
  //               Container(
  //                 height: 130.h,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: kColorScheme.primary,
  //                   borderRadius: const BorderRadius.vertical(
  //                     bottom: Radius.circular(30),
  //                   ),
  //                   image: const DecorationImage(
  //                     image: AssetImage(
  //                       'assets/images/img_bgAppbar.png',
  //                     ),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //               _buildDropDown(
  //                 listRack: controller.listRack,
  //                 rackName: controller.rackName.value,
  //                 onChangedRackName: controller.onChangedRackName,
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: Obx(
  //             () {
  //               return _buildRackContent(
  //                 context: context,
  //                 rackName: controller.rackName.value,
  //                 onDrawerClicked: controller.onDrawerClicked,
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // _buildDropDown({
  //   required List<String> listRack,
  //   required String rackName,
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
  //         selectedItem: rackName,
  //         onChange: onChangedRackName,
  //       ),
  //     ),
  //   );
  // }

  // // Fungsi untuk menampilkan konten berdasarkan rak yang dipilih
  // Widget _buildRackContent({
  //   String? rackName,
  //   BuildContext? context,
  //   required void Function() onDrawerClicked,
  // }) {
  //   switch (rackName) {
  //     case 'Rak 1':
  //       return _buildContentForRack1(onDrawerClicked: onDrawerClicked);
  //     case 'Rak 2':
  //       return _buildContentForRack2();
  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }

  // // Contoh widget konten untuk Rak 1
  // Widget _buildContentForRack1({
  //   required void Function() onDrawerClicked,
  // }) {
  //   return ListView.separated(
  //     shrinkWrap: true,
  //     padding: const EdgeInsets.only(
  //       top: 12,
  //       right: 0,
  //       left: 0,
  //       bottom: 0,
  //     ),
  //     itemBuilder: (context, index) {
  //       return GestureDetector(
  //         // onTap: onDrawerClicked,
  //         onTap: () {
  //           Get.to(
  //             () => const ListDrawerView(),
  //             arguments: {
  //               "numberDrawer": listDummyDrawer[index].numberDrawer,
  //             },
  //           );
  //         },
  //         child: UnconstrainedBox(
  //           child: Container(
  //             alignment: Alignment.center,
  //             width: MediaQuery.sizeOf(context).width / 2,
  //             decoration: BoxDecoration(
  //               color: kColorScheme.primary,
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Text(
  //               listDummyDrawer[index].numberDrawer.toString(),
  //               style: boldText28.copyWith(
  //                 color: Colors.white,
  //                 fontSize: 96.sp,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     separatorBuilder: (context, index) => const SizedBox(height: 10),
  //     itemCount: listDummyDrawer.length,
  //   );
  // }

  // // Contoh widget konten untuk Rak 2
  // Widget _buildContentForRack2() {
  //   return const Positioned(
  //     top: 100, // Sesuaikan posisi konten
  //     left: 0,
  //     right: 0,
  //     child: Text('Konten untuk Rak 2'),
    );
  }
}
