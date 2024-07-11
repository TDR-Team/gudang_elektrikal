import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';
import 'package:gudang_elektrikal/app/data/model/drawer.dart';
import 'package:gudang_elektrikal/app/modules/list_drawer/views/list_drawer_view.dart';
import 'package:gudang_elektrikal/app/widgets/dropdown_button.dart';
import '../controllers/get_components_controller.dart';

class GetComponentsView extends GetView<GetComponentsController> {
  const GetComponentsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => GetComponentsController());
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
                  _buildDropDown(
                    listRack: controller.listRack,
                    rackName: controller.rackName.value,
                    onChangedRackName: controller.onChangedRackName,
                  ),
                ],
              ),
            ),
            Obx(
              () {
                return _buildRackContent(
                  context: context,
                  rackName: controller.rackName.value,
                  onDrawerClicked: controller.onDrawerClicked,
                );
              },
            ),
          ],
        ),
        // Widget yang berubah sesuai dengan pilihan rak
      ),
    );
  }

  _buildDropDown({
    required List<String> listRack,
    required String rackName,
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
          selectedItem: rackName,
          onChange: onChangedRackName,
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan konten berdasarkan rak yang dipilih
  Widget _buildRackContent({
    String? rackName,
    BuildContext? context,
    required void Function() onDrawerClicked,
  }) {
    switch (rackName) {
      case 'Rak 1':
        return _buildContentForRack1(onDrawerClicked: onDrawerClicked);

      case 'Rak 2':
        return _buildContentForRack2();
      // Tambahkan case lainnya sesuai dengan jumlah rak
      default:
        return const SizedBox.shrink();
    }
  }

  // Contoh widget konten untuk Rak 1
  Widget _buildContentForRack1({
    required void Function() onDrawerClicked,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          // onTap: onDrawerClicked,
          onTap: () {
            Get.to(
              () => const ListDrawerView(),
              arguments: {
                "numberDrawer": listDummyDrawer[index].numberDrawer,
              },
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: UnconstrainedBox(
            child: Container(
              // padding: const EdgeInsets.symmetric(
              //     vertical: 50,
              //     // horizontal: 50,
              //     ),
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width / 2,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                listDummyDrawer[index].numberDrawer.toString(),
                style: boldText28.copyWith(
                  color: Colors.white,
                  fontSize: 96,
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: listDummyDrawer.length,
    );
  }

  // Contoh widget konten untuk Rak 2
  Widget _buildContentForRack2() {
    return const Positioned(
      top: 100, // Sesuaikan posisi konten
      left: 0,
      right: 0,
      child: Text('Konten untuk Rak 2'),
    );
  }
}
