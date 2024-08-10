import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListComponentsController extends GetxController {
  final String levelName = Get.arguments['levelName'];
  final String rackName = Get.arguments['rackName'];

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> components = <Map<String, dynamic>>[].obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComponents();
  }

  void fetchComponents() async {
    try {
      var levelSnapshot = await FirebaseFirestore.instance
          .collection('components')
          .doc(rackName)
          .get();

      if (levelSnapshot.exists) {
        var levelData =
            levelSnapshot.data()![levelName] as Map<String, dynamic>;

        components.value = levelData.entries.map((entry) {
          var componentData = entry.value as Map<String, dynamic>;
          return {
            'id': entry.key,
            'name': componentData['name'] ?? 'No name',
            'description': componentData['description'] ?? '',
            'stock': componentData['stock'] ?? 0,
            'unit': componentData['unit'] ?? '',
            'imgUrl': componentData['imgUrl'] ?? '',
          };
        }).toList();
      } else {
        components.value = [];
      }
    } catch (e) {
      print('Error fetching components: $e');
      components.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
