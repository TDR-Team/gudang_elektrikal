import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListDrawerController extends GetxController {
  //TODO: Implement ListDrawerController
  final int numberDrawer = Get.arguments['numberDrawer'];
    TextEditingController searchController = TextEditingController();


  final count = 0.obs;

  void increment() => count.value++;
}
