import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/add_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/edit_tools_view.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';

class ToolsController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxMap<String, List<Map<String, dynamic>>> categorizedTools =
      <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTools();
  }

  Future<void> fetchTools() async {
    isLoading.value = true;
    try {
      final QuerySnapshot categorySnapshot =
          await FirebaseFirestore.instance.collection('tools').get();

      Map<String, List<Map<String, dynamic>>> toolsData = {};

      for (var categoryDoc in categorySnapshot.docs) {
        String categoryName = categoryDoc.id;

        final toolsMap = categoryDoc.data() as Map<String, dynamic>;

        List<Map<String, dynamic>> toolsList = toolsMap.entries.map((entry) {
          return {
            'id': entry.key,
            'name': entry.value['name'] ?? 'No name',
            'description': entry.value['description'] ?? '',
            'stock': entry.value['stock'] ?? 0,
            'tStock': entry.value['tStock'] ?? 0,
            'imgUrl': entry.value['imgUrl'] ?? '',
          };
        }).toList();

        toolsData[categoryName] = toolsList;
      }

      categorizedTools.value = toolsData;
    } catch (e) {
      print('Error fetching tools: $e');
      categorizedTools.value = {};
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

  void onEditToolsClicked(String categoryName, String toolsId) {
    final selectedTools = categorizedTools[categoryName]!.firstWhere(
      (tools) => tools['id'] == toolsId,
    );
    Get.to(
      () => const EditToolsView(),
      arguments: {
        "tools": selectedTools, // Pass the selected tools data
        "toolsId": toolsId, // Pass the tools ID
        "categoryId": categoryName,
      },
    )?.then((value) async {
      searchController.clear();
      await fetchTools();
    });
  }

  Future<void> onDeleteToolsClicked(String categoryName, String toolsId) async {
    try {
      // Delete
      await FirebaseFirestore.instance
          .collection('tools')
          .doc(categoryName)
          .update({
        toolsId: FieldValue.delete(),
      });

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

  void onUnderDev() {
    const CustomSnackbar(
      success: false,
      title: 'Mohon maaf',
      message: 'Fitur ini sedang dalam pengembangan',
    ).showSnackbar();
  }
}
