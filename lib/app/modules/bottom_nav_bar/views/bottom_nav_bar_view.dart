import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/widgets/title_text.dart';

import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarView extends GetView<BottomNavBarController> {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    // Get.put(ProfileController());
    // ProductController permintaan = Get.put(ProductController());
    // Get.put(RiwayatController());
    // Get.put(BottomNavigationBarController(), permanent: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // body: controller.pages.elementAt(controller.currentIndex.value),
      body: Obx(() => controller.pages[controller.currentIndex.value]),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
      ),
      // floatingActionButton: FloatingActionButton(
      //   shape: const CircleBorder(),
      //   backgroundColor: secondaryShade3,
      //   child: Center(
      //     child: Image.asset(
      //       'assets/img/plus.png',
      //       width: 24,
      //       height: 24,
      //     ),
      //   ),
      //   onPressed: () {
      //     Get.toNamed(Routes.ADD_PRODUCT)
      //         ?.then((value) => permintaan.fetchAllPermintaan());
      //   },
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(
            color: Colors.transparent,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          showModalBottomSheet(
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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.withOpacity(0.6),
                            ),
                            child: const Divider(
                              // indent: 150,
                              // endIndent: 150,
                              height: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TitleText(
                          title: 'Pilih Opsi Layanan Laundry',
                          textStyle: semiBoldText20,
                        ),
                        const SizedBox(height: 10),

                        InkWell(
                          // onTap: () => Get.to(
                          //   () => DetailServiceView(
                          //     isCuciLipat: true,
                          //   ),
                          // ),
                          onTap: () {},
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              // color: Colors.blue.withOpacity(0.1),
                              border: Border.all(color: Colors.blue),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Image.asset(
                                  'assets/images/ic_cucilipat.png',
                                  height: 70,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Cuci Lipat',
                                      style: boldText24.copyWith(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Harga mulai dari Rp6.000',
                                      style: regularText10.copyWith(
                                        color: Colors.blue.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          // onTap: () => Get.to(
                          //   () => DetailServiceView(
                          //     isCuciLipat: true,
                          //   ),
                          // ),
                          onTap: () {},
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              // color: Colors.blue.withOpacity(0.1),
                              border: Border.all(color: Colors.blue),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Image.asset(
                                  'assets/images/ic_laundrysatuan.png',
                                  height: 70,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Laundry Satuan',
                                      style: boldText24.copyWith(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Harga mulai dari Rp10.000',
                                      style: regularText10.copyWith(
                                        color: Colors.blue.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        InkWell(
                          // onTap: () => Get.to(
                          //   () => DetailServiceView(
                          //     isCuciSetrika: true,
                          //   ),
                          // ),
                          onTap: () {},
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              // color: Colors.blue.withOpacity(0.1),
                              border: Border.all(color: Colors.blue),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Image.asset(
                                  'assets/images/ic_cucisetrika.png',
                                  height: 70,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Cuci Setrika',
                                      style: boldText24.copyWith(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Harga mulai dari Rp7.000',
                                      style: regularText10.copyWith(
                                        color: Colors.blue.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // CustomTextField(,
                        //   label: 'Add New Task',
                        //   controller: controller.textEditingController,
                        //   hintText: 'New Task',
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     // CustomElevatedButton(
                        //     //   onPressed: () {
                        //     //     controller.handleCreateTodo();
                        //     //     Navigator.pop(context);
                        //     //   },
                        //     //   text: 'Save',
                        //     //   textColor: Colors.black,
                        //     //   backgroundColor: Colors.greenAccent,
                        //     //   borderSide: const BorderSide(
                        //     //     color: Colors.greenAccent,
                        //     //   ),
                        //     //   minWidth: 0,
                        //     //   minHeight: 30,
                        //     // ),
                        //     CustomElevatedButton(
                        //       onPressed: () {},
                        //       text: 'Kembali',
                        //       textStyle: semiBoldText16.copyWith(
                        //         color: kColorScheme.primary,
                        //       ),
                        //       buttonStyle: primary500BorderButton,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
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
          height: 60,
          color: Colors.white,
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
                        SvgPicture.asset(
                          "assets/ic_getComponents.svg",
                          width: 34,
                          height: 34,
                          color: currentIndex == 0 ? Colors.black : Colors.grey,
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
                          color: currentIndex == 0 ? Colors.black : Colors.grey,
                        ),
                        Expanded(
                          child: Text(
                            'Pinjam Alat',
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
                        // Image.asset(
                        //   'assets/img/transaction.png',
                        //   width: 24,
                        //   height: 24,
                        //   color: currentIndex == 2 ? Colors.black : Colors.grey,
                        // ),
                        Text(
                          'Aktivitas',
                          style: TextStyle(
                            color:
                                currentIndex == 2 ? Colors.black : Colors.grey,
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
                        // Image.asset(
                        //   'assets/img/profile.png',
                        //   width: 24,
                        //   height: 24,
                        //   color: currentIndex == 3 ? Colors.black : Colors.grey,
                        // ),
                        Text(
                          'Profil',
                          style: TextStyle(
                            color:
                                currentIndex == 3 ? Colors.black : Colors.grey,
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

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => BottomNavBarController());
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Obx(() => controller.pages[controller.currentIndex.value]),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//           side: const BorderSide(
//             color: Colors.transparent,
//             strokeAlign: BorderSide.strokeAlignOutside,
//           ),
//         ),
//         backgroundColor: Colors.lightBlue,
//         elevation: 0,
//         child: const Icon(
//           Icons.add_rounded,
//           color: Colors.white,
//           size: 40,
//         ),
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             backgroundColor: Colors.white,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             isScrollControlled: true,
//             builder: (context) {
//               return Padding(
//                 padding: MediaQuery.of(context).viewInsets,
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: 60,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(100),
//                               color: Colors.grey.withOpacity(0.6),
//                             ),
//                             child: const Divider(
//                               // indent: 150,
//                               // endIndent: 150,
//                               height: 4,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         TitleText(
//                           title: 'Pilih Opsi Layanan Laundry',
//                           textStyle: semiBoldText20,
//                         ),
//                         const SizedBox(height: 10),

//                         InkWell(
//                           // onTap: () => Get.to(
//                           //   () => DetailServiceView(
//                           //     isCuciLipat: true,
//                           //   ),
//                           // ),
//                           onTap: () {},
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               // color: Colors.blue.withOpacity(0.1),
//                               border: Border.all(color: Colors.blue),
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(10),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 16),
//                                 Image.asset(
//                                   'assets/images/ic_cucilipat.png',
//                                   height: 70,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Cuci Lipat',
//                                       style: boldText24.copyWith(
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Harga mulai dari Rp6.000',
//                                       style: regularText10.copyWith(
//                                         color: Colors.blue.withOpacity(0.7),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         InkWell(
//                           // onTap: () => Get.to(
//                           //   () => DetailServiceView(
//                           //     isCuciLipat: true,
//                           //   ),
//                           // ),
//                           onTap: () {},
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               // color: Colors.blue.withOpacity(0.1),
//                               border: Border.all(color: Colors.blue),
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(10),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 16),
//                                 Image.asset(
//                                   'assets/images/ic_laundrysatuan.png',
//                                   height: 70,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Laundry Satuan',
//                                       style: boldText24.copyWith(
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Harga mulai dari Rp10.000',
//                                       style: regularText10.copyWith(
//                                         color: Colors.blue.withOpacity(0.7),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 10),
//                         InkWell(
//                           // onTap: () => Get.to(
//                           //   () => DetailServiceView(
//                           //     isCuciSetrika: true,
//                           //   ),
//                           // ),
//                           onTap: () {},
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               // color: Colors.blue.withOpacity(0.1),
//                               border: Border.all(color: Colors.blue),
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(10),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 16),
//                                 Image.asset(
//                                   'assets/images/ic_cucisetrika.png',
//                                   height: 70,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Cuci Setrika',
//                                       style: boldText24.copyWith(
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Harga mulai dari Rp7.000',
//                                       style: regularText10.copyWith(
//                                         color: Colors.blue.withOpacity(0.7),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 10),
//                         // CustomTextField(,
//                         //   label: 'Add New Task',
//                         //   controller: controller.textEditingController,
//                         //   hintText: 'New Task',
//                         // ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.end,
//                         //   children: [
//                         //     // CustomElevatedButton(
//                         //     //   onPressed: () {
//                         //     //     controller.handleCreateTodo();
//                         //     //     Navigator.pop(context);
//                         //     //   },
//                         //     //   text: 'Save',
//                         //     //   textColor: Colors.black,
//                         //     //   backgroundColor: Colors.greenAccent,
//                         //     //   borderSide: const BorderSide(
//                         //     //     color: Colors.greenAccent,
//                         //     //   ),
//                         //     //   minWidth: 0,
//                         //     //   minHeight: 30,
//                         //     // ),
//                         //     CustomElevatedButton(
//                         //       onPressed: () {},
//                         //       text: 'Kembali',
//                         //       textStyle: semiBoldText16.copyWith(
//                         //         color: kColorScheme.primary,
//                         //       ),
//                         //       buttonStyle: primary500BorderButton,
//                         //     ),
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             currentIndex: controller.currentIndex.value,
//             backgroundColor: Colors.white,
//             selectedItemColor: Colors.lightBlue,
//             unselectedItemColor: Colors.grey.withOpacity(0.8),
//             onTap: (index) {
//               controller.changePage(index);
//             },
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Ambil Komponen',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Pinjam Alat',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Aktivitas',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profil',
//               ),
//             ],
//           )),
//     );
//   }
// }
