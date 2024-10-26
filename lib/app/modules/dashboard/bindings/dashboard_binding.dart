import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/components/controllers/components_controller.dart';
import 'package:gudang_elektrikal/app/modules/history/controllers/history_controller.dart';
import 'package:gudang_elektrikal/app/modules/profile/controllers/profile_controller.dart';
import 'package:gudang_elektrikal/app/modules/tools/controllers/tools_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<ComponentsController>(
      () => ComponentsController(),
    );
     Get.lazyPut<ToolsController>(
      () => ToolsController(),
    );
     Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
     Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
