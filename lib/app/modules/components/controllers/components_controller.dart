import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/components/views/list_components_view.dart';

class ComponentsController extends GetxController {
  //TODO: Implement ComponentsController

  final rackName = 'Rak 1'.obs;
  // final Drawer listDummyDrawer = ;
  final listRack = [
    'Rak 1',
    'Rak 2',
    'Rak 3',
    'Rak 4',
    'Rak 5',
    'Rak 6',
    'Rak 7',
    'Rak 8',
    'Rak 9',
    'Rak 10',
    'Rak 11',
    'Rak 12',
  ];

  void onChangedRackName(String? value) {
    rackName.value = value ?? "";
  }

  void onDrawerClicked() {
    Get.to(
      () => const ListComponentsView(),
      arguments: {
        // "drawer": listDummyDrawer,
      },
    );
  }

  // void onDrawerClicked(int index) {
  //   Get.to(
  //     () => const ListDrawerView(),
  //     arguments: {
  //       "number_drawer": index + 1,
  //     },
  //   );
  // }
}
