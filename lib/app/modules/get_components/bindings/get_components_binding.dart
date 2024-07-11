import 'package:get/get.dart';

import '../controllers/get_components_controller.dart';

class GetComponentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetComponentsController>(
      () => GetComponentsController(),
    );
  }
}
