import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

import '../controllers/list_drawer_controller.dart';

class ListDrawerView extends GetView<ListDrawerController> {
  const ListDrawerView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ListDrawerController());
    var sizeHeight = MediaQuery.sizeOf(context).height;
    var sizeWidth = MediaQuery.sizeOf(context).width;
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
            Container(
              width: double.infinity,
              // height: sizeHeight * 0.1,
              // padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://picsum.photos/200/300',
                      height: sizeHeight * 0.06,
                      width: sizeHeight * 0.06,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nama Barang',
                          overflow: TextOverflow.ellipsis,
                          // style: boldText20,

                          style: boldText20.copyWith(
                            // fontSize:
                            //     (sizeHeight * 0.03 + sizeWidth * 0.03) / 2,
                            fontSize: 20.sp,
                          ),
                          // textScaler: 1.0,
                        ),
                        Text(
                          'Lorem ipsum dolore sir amet bla bla bla bla bla bla bla bla Lorem ipsum dolore sir amet bla bla bla bla bla bla bla bla ....',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: regularText12.copyWith(
                            // fontSize:
                            //     (sizeHeight * 0.015 + sizeWidth * 0.015) / 2,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Stok : 20',
                          style: semiBoldText14.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Obx(
            //   () {
            //     return Container(
            //       width: double.infinity,
            //       height: 30,
            //       decoration: const BoxDecoration(
            //         color: Colors.amber,
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
