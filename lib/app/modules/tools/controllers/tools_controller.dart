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

      tools.value = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'No name',
          'description': doc['description'] ?? '',
          'stock': doc['stock'] ?? 0,
          'tStock': doc['tStock'] ?? 0,
          'status': doc['status'] ?? false,
          'imgUrl': doc['imgUrl'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error fetching tools: $e');
      tools.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
