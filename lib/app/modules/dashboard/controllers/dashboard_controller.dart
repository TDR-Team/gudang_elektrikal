import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/history/controllers/history_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;

    if (index == 3) {
      final historyController = Get.find<HistoryController>();
      historyController.fetchActivities();
      historyController.fetchBorrowed();
    }

    update();
  }
}
