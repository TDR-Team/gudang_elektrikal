import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/styles/colors.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
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
          'Komponen',
          style: semiBoldText20,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                controller.addLevel();
              },
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
                      image: AssetImage('assets/images/img_bgAppbar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _buildDropDown(
                  listRack: controller.rackNames,
                  onChangedRackName: controller.onChangedRackNames,
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                // Check if a rack is selected
                if (controller.rackName.value.isEmpty) {
                  return Center(
                    child: Text(
                      'Pilih Rak untuk melihat level',
                      style: semiBoldText20,
                    ),
                  );
                }

                // If levels are loading
                if (controller.isLoadingLevels.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // If levels are fetched
                if (controller.listLevels.isNotEmpty) {
                  return _buildRackLevels(
                    context: context,
                    rackName: controller.rackName.value,
                    levels: controller.listLevels,
                    onLevelClicked: controller.onLevelClicked,
                  );
                } else {
                  return Center(
                    child: Text(
                      'Tidak ada level untuk rak ini.',
                      style: semiBoldText20,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildDropDown({
    required List<String> listRack,
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
          hintText: 'Pilih Rak',
          onChange: onChangedRackName,
        ),
      ),
    );
  }

  Widget _buildRackLevels({
    required String rackName,
    required BuildContext context,
    required List<String> levels,
    required void Function(String rackName, String levelName) onLevelClicked,
  }) {
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
          onTap: () => onLevelClicked(rackName, levels[index]),
          child: UnconstrainedBox(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width / 1.1,
              decoration: BoxDecoration(
                color: kColorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                levels[index],
                style: boldText28.copyWith(
                  color: Colors.white,
                  fontSize: 75.sp,
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: levels.length,
    );
  }
}
