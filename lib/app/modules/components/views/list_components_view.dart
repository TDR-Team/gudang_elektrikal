import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/list_components_controller.dart';
import 'package:gudang_elektrikal/app/widgets/custom_list_drawer.dart';
import 'package:gudang_elektrikal/app/widgets/custom_search.dart';
import 'package:shimmer/shimmer.dart';

class ListComponentsView extends GetView<ListComponentsController> {
  const ListComponentsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ListComponentsController());
    // var sizeHeight = MediaQuery.sizeOf(context).height;
    // var sizeWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 231, 231),
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
                  child: Center(
                    child: Text(
                      controller.numberDrawer.toString(),
                      style: boldText28.copyWith(
                        color: Colors.white,
                        fontSize: 48.sp,
                      ),
                      textScaler: const TextScaler.linear(1),
                    ),
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearch(
                      searchController: controller.searchController,
                      //                       onTap: () {
                      //                         FocusScope.of(context).unfocus();

                      // // This is the correct approach of calling unfocus on primary focus
                      //                         FocusManager.instance.primaryFocus!.unfocus();
                      //                         TextEditingController().clear();
                      //                       },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                top: 12,
                left: 16,
                right: 16,
                bottom: 0,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: 10,
              itemBuilder: (context, index) {
                return CustomListComponents(
                  id: '1',
                  name: 'Kabel Gorong',
                  imgUrl: 'https://picsum.photos/200/300',
                  description:
                      'Lorem ipsum dolore sir amet bla bla bla bla bla bla bla bla Lorem ipsum dolore sir amet bla bla bla bla bla bla bla bla ....',
                  stock: 10,
                  unit: 'Meter',
                  onTapDetail: () {
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
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 80.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      'https://picsum.photos/200/300',
                                      height: 200.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Shimmer.fromColors(
                                            baseColor: const Color.fromARGB(
                                                255, 148, 148, 148),
                                            highlightColor:
                                                const Color.fromARGB(
                                                    255, 102, 95, 95),
                                            child: Container(
                                              height: 60.h,
                                              width: 60.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 250.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 30,
                                            color:
                                                Color.fromARGB(255, 53, 53, 53),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Kabel Gorong',
                                            style: boldText20,
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '20 Pcs',
                                          style: semiBoldText14,
                                          textScaler:
                                              const TextScaler.linear(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras ut pretium metus. Donec viverra magna mi, ac semper diam condimentum ac. Pellentesque ac aliquam nulla. Fusce feugiat aliquet lectus, vel pretium velit fringilla sit amet. Maecenas id congue ex. Aenean leo ligula, malesuada quis tempor eu, aliquet in mauris. Integer eget gravida elit, dignissim condimentum nulla. Vivamus pellentesque dignissim feugiat. Sed cursus tortor a risus aliquam tempus. Sed commodo sit amet justo non efficitur.',
                                    style: regularText10,
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // CustomElevatedButton(
                                      //   onPressed: () {},
                                      //   text: 'Ubah',
                                      //   // buttonStyle:
                                      //   //     primary300Button.copyWith(
                                      //   //   padding:
                                      //   //       const WidgetStatePropertyAll(
                                      //   //     EdgeInsets.symmetric(vertical: 2),
                                      //   //   ),
                                      //   // ),
                                      //   buttonStyle: ElevatedButton.styleFrom(
                                      //     backgroundColor:
                                      //         const Color.fromRGBO(
                                      //             100, 201, 212, 1.0),
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(10.0),
                                      //     ),
                                      //     padding: const EdgeInsets.symmetric(
                                      //       vertical: 8,
                                      //     ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Ubah',
                                              style: semiBoldText16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 24.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onTapEdit: () {},
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}
