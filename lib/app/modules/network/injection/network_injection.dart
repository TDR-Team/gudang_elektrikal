import 'package:get/get.dart';

import '../controller/network_controller.dart';

class NetworkInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}