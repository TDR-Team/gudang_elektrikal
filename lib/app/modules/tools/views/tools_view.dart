import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/widgets/custom_list_tools.dart';
import 'package:gudang_elektrikal/app/widgets/custom_search.dart';

import '../../../common/theme/font.dart';
import '../controllers/tools_controller.dart';

class ToolsView extends GetView<ToolsController> {
  const ToolsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ToolsController());
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.tools.isEmpty) {
                return const Center(child: Text("No tools found"));
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 16,
                    right: 16,
                    bottom: 0,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: controller.tools.length,
                  itemBuilder: (context, index) {
                    var tools = controller.tools[index];
                    return CustomListTools(
                      id: tools['id'],
                      name: tools['name'],
                      imgUrl:
                          tools['imgUrl'] ?? 'https://picsum.photos/200/300',
                      description:
                          tools['description'] ?? 'No description available',
                      stock: tools['stock'],
                      tStock: tools['tStock'],
                      isStatus: tools['stock'] != 0,
                      onTapEdit: () {
                        controller.onEditToolsClicked(tools['id']);
                      },
                      onTapDelete: () {
                        controller.onDeleteToolsClicked(tools['id']);
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: FloatingActionButton(
            heroTag: "addTools",
            onPressed: () {
              controller.onAddToolsClicked();
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
