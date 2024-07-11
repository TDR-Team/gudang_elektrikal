import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/list_drawer_controller.dart';

class ListDrawerView extends GetView<ListDrawerController> {
  const ListDrawerView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ListDrawerController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.numberDrawer.toString(),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ListDrawerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
