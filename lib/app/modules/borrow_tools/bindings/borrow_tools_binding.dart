import 'package:get/get.dart';

import '../controllers/borrow_tools_controller.dart';

class BorrowToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BorrowToolsController>(
      () => BorrowToolsController(),
    );
  }
}
