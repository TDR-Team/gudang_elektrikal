import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/borrow_tools_controller.dart';

class BorrowToolsView extends GetView<BorrowToolsController> {
  const BorrowToolsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BorrowToolsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BorrowToolsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
