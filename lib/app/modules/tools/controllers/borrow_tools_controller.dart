import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BorrowToolsController extends GetxController {
  //TODO: Implement BorrowToolsController
  TextEditingController searchController = TextEditingController();

  final count = 0.obs;

  void increment() => count.value++;
}
