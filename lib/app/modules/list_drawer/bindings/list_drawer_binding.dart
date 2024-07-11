import 'package:get/get.dart';

import '../controllers/list_drawer_controller.dart';

class ListDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListDrawerController>(
      () => ListDrawerController(),
    );
  }
}
