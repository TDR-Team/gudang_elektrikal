import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/tools/controllers/add_tools_controller.dart';
import 'package:gudang_elektrikal/app/modules/tools/controllers/edit_tools_controller.dart';

import '../controllers/tools_controller.dart';

class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToolsController>(
      () => ToolsController(),
    );
    Get.lazyPut<AddToolsController>(
      () => AddToolsController(),
    );
    Get.lazyPut<EditToolsController>(
      () => EditToolsController(),
    );
  }
}
