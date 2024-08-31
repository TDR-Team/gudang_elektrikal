import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/add_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/edit_tools_view.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

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
            // 'isStatus': tools['isStatus'] ?? false,
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

  void onAddToolsClicked() {
    Get.to(
      () => const AddToolsView(),
    )?.then((value) async {
      searchController.clear();
      await fetchTools();
    });
  }

  void onEditToolsClicked(String toolsId) {
    final selectedTools = tools.firstWhere(
      (tools) => tools['id'] == toolsId,
    );
    Get.to(
      () => const EditToolsView(),
      arguments: {
        "tools": selectedTools, // Pass the selected tools data
        "toolsId": toolsId, // Pass the tools ID
      },
    )?.then((value) async {
      searchController.clear();
      await fetchTools();
    });
  }

  Future<void> onDeleteToolsClicked(String toolsId) async {
    try {
      // Delete
      await FirebaseFirestore.instance
          .collection('tools')
          .doc(toolsId)
          .delete();

      Get.back();
      // Show success snackbar
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Alat Berhasil Dihapus',
      ).showSnackbar();

      // Update the tools list
      await fetchTools();
    } catch (e) {
      print('Error deleting tools: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Alat',
      ).showSnackbar();
    }
  }
}
