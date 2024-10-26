import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/add_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/edit_tools_view.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';
import 'package:uuid/uuid.dart';

class GetToolsController extends GetxController {
  TextEditingController stockController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxMap<String, List<Map<String, dynamic>>> categorizedTools =
      <String, List<Map<String, dynamic>>>{}.obs;
  RxList<Map<String, dynamic>> tools = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredTools = <Map<String, dynamic>>[].obs;
  Map<String, List<Map<String, dynamic>>> toolsData = {};
  List<Map<String, dynamic>> toolsList = [];

  FocusNode stockFocusNode = FocusNode();
  RxInt stock = 1.obs;

  String? userName;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
    fetchTools();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    stockController.text = '1';
    searchController.clear();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    stockController.dispose();
    stockFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchTools() async {
    isLoading.value = true;
    try {
      final QuerySnapshot categorySnapshot =
          await FirebaseFirestore.instance.collection('tools').get();

      for (var categoryDoc in categorySnapshot.docs) {
        String categoryName = categoryDoc.id;

        final toolsMap = categoryDoc.data() as Map<String, dynamic>;

        toolsList = toolsMap.entries.map((entry) {
          return {
            'id': entry.key,
            'name': entry.value['name'] ?? 'No name',
            'description': entry.value['description'] ?? '',
            'stock': entry.value['stock'] ?? 0,
            'tStock': entry.value['tStock'] ?? 0,
            'imgUrl': entry.value['imgUrl'] ?? '',
            'selectedStock': 1,
          };
        }).toList();

        // tools.value = toolsMap.entries.map((entry) {
        //   var toolsData = entry.value as Map<String, dynamic>;
        //   return {
        //     'id': entry.key,
        //     'name': toolsData['name'] ?? 'No name',
        //     'description': toolsData['description'] ?? '',
        //     'stock': toolsData['stock'] ?? 0,
        //     'tStock': toolsData['tStock'] ?? 0,
        //     'imgUrl': toolsData['imgUrl'] ?? '',
        //     'selectedStock': 1,
        //   };
        // }).toList();

        toolsData[categoryName] = toolsList;
      }

      categorizedTools.value = toolsData;
    } catch (e) {
      debugPrint('Error fetching tools: $e');
      categorizedTools.value = {};
    } finally {
      isLoading.value = false;
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      categorizedTools.value = toolsData;
      return;
    }

    final filteredTools = <String, List<Map<String, dynamic>>>{};

    toolsData.forEach((categoryName, toolsList) {
      final matchingTools = toolsList.where((tool) {
        final toolName = tool['name'].toString().toLowerCase();
        return toolName.contains(query);
      }).toList();

      if (matchingTools.isNotEmpty) {
        filteredTools[categoryName] = matchingTools;
      }
    });

    categorizedTools.value = filteredTools;
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
      // Ambil data tools berdasarkan categoryName dan toolsId
      final toolsDoc = await FirebaseFirestore.instance
          .collection('tools')
          .doc(categoryName)
          .get();

      final toolsMap = toolsDoc.data();
      final toolsData = toolsMap?[toolsId] as Map<String, dynamic>? ?? {};

      // Hapus tools
      await FirebaseFirestore.instance
          .collection('tools')
          .doc(categoryName)
          .update({
        toolsId: FieldValue.delete(),
      });

      // Log data alat yang dihapus ke dalam riwayat aktivitas
      final logData = {
        toolsId: toolsData,
      };

      await _logHistoryActivity(logData);

      Get.back();
      // Tampilkan snackbar sukses
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Alat Berhasil Dihapus',
      ).showSnackbar();

      // Perbarui daftar alat
      await fetchTools();
    } catch (e) {
      debugPrint('Error deleting tools: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Alat',
      ).showSnackbar();
    }
  }

  // GET TOOLS
  // Increment Function
  void increment(String categoryName, String toolsId) {
    // Cari item berdasarkan categoryName dan toolsId
    final tool = categorizedTools[categoryName]?.firstWhere(
      (tool) => tool['id'] == toolsId,
    );

    if (tool != null) {
      int currentStock = tool['selectedStock'] ?? 1;
      int availableStock = tool['stock'] ?? 0;

      if (currentStock < availableStock) {
        tool['selectedStock'] = currentStock + 1;
        stockController.text = tool['selectedStock'].toString();
        categorizedTools.refresh(); // Refresh untuk memperbarui UI
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Sudah Maksimal',
          message:
              'Tidak dapat mengambil komponen melebihi batas stok yang tersedia',
        ).showSnackbar();
      }
    }
  }

// Decrement Function
  void decrement(String categoryName, String toolsId) {
    final tool = categorizedTools[categoryName]?.firstWhere(
      (tool) => tool['id'] == toolsId,
    );

    if (tool != null) {
      int currentStock = tool['selectedStock'] ?? 1;

      if (currentStock > 1) {
        tool['selectedStock'] = currentStock - 1;
        stockController.text = tool['selectedStock'].toString();
        categorizedTools.refresh(); // Refresh untuk memperbarui UI
      }
    }
  }

  void onGetToolsClicked(String categoryName, String toolsId) async {
    try {
      if (!categorizedTools.containsKey(categoryName)) {
        debugPrint('Category not found in categorizedTools');
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Kategori tidak ditemukan.',
        ).showSnackbar();
        return;
      }

      // Cari alat berdasarkan `toolsId`
      final toolIndex = categorizedTools[categoryName]?.indexWhere(
        (tool) => tool['id'] == toolsId,
      );

      if (toolIndex == null || toolIndex == -1) {
        debugPrint('Tool ID not found in the category tools');
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Komponen tidak ditemukan.',
        ).showSnackbar();
        return;
      }

      final selectedTool = categorizedTools[categoryName]![toolIndex];
      int selectedStock = selectedTool['selectedStock'] ?? 1;
      int availableStock = selectedTool['stock'] ?? 0;

      if (selectedStock > 0) {
        int newStock = availableStock - selectedStock;

        // Referensi ke dokumen di Firebase berdasarkan categoryName
        DocumentReference toolsRef =
            FirebaseFirestore.instance.collection('tools').doc(categoryName);

        if (newStock <= 0) {
          // Jika stok baru kurang dari atau sama dengan nol, hapus item dari Firebase
          await toolsRef.update({
            toolsId: FieldValue.delete(),
            '$toolsId.deleteAt': FieldValue.serverTimestamp(),
          });

          // Hapus item dari daftar lokal
          categorizedTools[categoryName]!.removeAt(toolIndex);
        } else {
          // Jika stok masih tersisa, perbarui stok di Firebase
          await toolsRef.update({
            '$toolsId.stock': newStock,
            '$toolsId.updatedAt': FieldValue.serverTimestamp(),
          });

          // Perbarui stok di data lokal
          categorizedTools[categoryName]![toolIndex]['stock'] = newStock;
          categorizedTools[categoryName]![toolIndex]['selectedStock'] = 1;
        }

        // Refresh UI dan tampilkan pesan sukses
        categorizedTools.refresh();
        Get.back();
        const CustomSnackbar(
          success: true,
          title: 'Berhasil',
          message: 'Komponen berhasil diambil.',
        ).showSnackbar();
      } else {
        // Tampilkan pesan jika stok tidak valid
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Stok yang diambil tidak valid.',
        ).showSnackbar();
        Get.back();
      }
    } catch (e) {
      log.e('Error getting tools: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal mengambil komponen.',
      ).showSnackbar();
      Get.back();
    }
  }

  Future<void> _getUserData() async {
    try {
      update();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        update();

        // Convert DocumentSnapshot to Map<String, dynamic>
        Map<String, dynamic> data =
            userData.data() as Map<String, dynamic>? ?? {};

        // Check if the document exists
        if (userData.exists) {
          userName = data['name'] ?? '';
          update();
        } else {
          // Handle case where document does not exist
          userName = '';
          update();
        }
      }
      update();
    } catch (e) {
      debugPrint('Error getting profile data: $e');
    } finally {
      update();
    }
  }

  Future<void> _logHistoryActivity(
    Map<String, dynamic> toolsData,
  ) async {
    try {
      final activityId =
          const Uuid().v4(); // Generate a unique ID for the activity
      await FirebaseFirestore.instance
          .collection('history')
          .doc('activities')
          .set({
        activityId: {
          'user': userName,
          'itemType': "tools",
          'actionType': "delete",
          'itemData': toolsData,
          'timestamp': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      log.e('Failed to log activity: $e');
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
