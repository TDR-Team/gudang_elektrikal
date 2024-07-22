import 'package:get/get.dart';

class ListDrawerController extends GetxController {
  //TODO: Implement ListDrawerController
  final int numberDrawer = Get.arguments['numberDrawer'];

  final count = 0.obs;

  void increment() => count.value++;
}
