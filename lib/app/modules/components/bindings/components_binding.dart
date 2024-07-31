import 'package:get/get.dart';

import 'package:gudang_elektrikal/app/modules/components/controllers/list_components_controller.dart';
import '../controllers/components_controller.dart';

class ComponentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListComponentsController>(
      () => ListComponentsController(),
    );
    Get.lazyPut<ComponentsController>(
      () => ComponentsController(),
    );
  }
}
