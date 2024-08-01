import 'package:flutter/material.dart';

import 'package:get/get.dart';

class EditComponentsView extends GetView {
  const EditComponentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditComponentsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditComponentsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
