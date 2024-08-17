import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ToolsController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> tools = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTools();
  }

  Future<void> fetchTools() async {
    isLoading.value = true;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tools').get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Documents found: ${querySnapshot.docs.length}');
        tools.value = querySnapshot.docs.map((tools) {
          print(tools.data()); // Print each document's data for debugging
          return {
            'id': tools.id,
            'name': tools['name'] ?? 'No name',
            'description': tools['description'] ?? '',
            'stock': tools['stock'] ?? 0,
            'tStock': tools['tStock'] ?? 0,
            'isStatus': tools['isStatus'] ?? false,
            'imgUrl': tools['imgUrl'] ?? '',
          };
        }).toList();
      } else {
        tools.value = [];
        print('No documents found');
      }
    } catch (e) {
      print('Error fetching tools: $e');
      tools.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
