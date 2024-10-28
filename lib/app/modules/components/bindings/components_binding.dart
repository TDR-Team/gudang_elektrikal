import 'package:get/get.dart';

import 'package:gudang_elektrikal/app/modules/components/controllers/add_components_controller.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/edit_components_controller.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/get_components_controller.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/list_components_controller.dart';

class ComponentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetComponentsController>(
      () => GetComponentsController(),
    );
    Get.lazyPut<EditComponentsController>(
      () => EditComponentsController(),
    );
    Get.lazyPut<AddComponentsController>(
      () => AddComponentsController(),
    );
    Get.lazyPut<ListComponentsController>(
      () => ListComponentsController(),
    );
  }
}
