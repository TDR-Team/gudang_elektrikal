import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/add_tools_view.dart';
import 'package:gudang_elektrikal/app/modules/tools/views/edit_tools_view.dart';
import 'package:gudang_elektrikal/app/utils/logging.dart';
import 'package:gudang_elektrikal/app/widgets/custom_snackbar.dart';
import 'package:uuid/uuid.dart';

class ToolsController extends GetxController {
  TextEditingController stockController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController addCategoryController = TextEditingController();
  TextEditingController editCategoryController = TextEditingController();

  RxString categoryName = ''.obs;
  RxBool isLoading = true.obs;
  RxMap<String, List<Map<String, dynamic>>> categorizedTools =
      <String, List<Map<String, dynamic>>>{}.obs;
  RxList<Map<String, dynamic>> tools = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredTools = <Map<String, dynamic>>[].obs;
  Map<String, List<Map<String, dynamic>>> toolsData = {};

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

        // Buat daftar alat dan urutkan berdasarkan nama
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

        // Urutkan toolsList berdasarkan 'name' secara alfabetis
        toolsList.sort((a, b) => a['name'].compareTo(b['name']));

        // Masukkan toolsList yang sudah diurutkan ke dalam toolsData
        toolsData[categoryName] = toolsList;
      }

      // Urutkan kunci kategori secara alfabetis sebelum diatur ke categorizedTools
      List<String> sortedKeys = toolsData.keys.toList()..sort();
      categorizedTools.value = {
        for (var key in sortedKeys) key: toolsData[key] ?? []
      };
    } catch (e) {
      debugPrint('Error fetching tools: $e');
      categorizedTools.value = {};
    } finally {
      isLoading.value = false;
    }
  }

  void addCategory(String addcategoryName) async {
    if (addcategoryName.isEmpty) {
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Nama kategori tidak boleh kosong.',
      ).showSnackbar();
      return;
    }

    try {
      // Check if category already exists
      DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
          .collection('tools')
          .doc(addcategoryName)
          .get();

      if (categoryDoc.exists) {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Kategori sudah ada.',
        ).showSnackbar();
      } else {
        // Add a new document with the specified category name
        await FirebaseFirestore.instance
            .collection('tools')
            .doc(addcategoryName)
            .set({});

        const CustomSnackbar(
          success: true,
          title: 'Berhasil',
          message: 'Kategori berhasil ditambahkan.',
        ).showSnackbar();

        // Update the tools list after adding the category
        update();
        fetchTools();
        categoryName.value = '';
      }
    } catch (e) {
      debugPrint('Error adding category: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal menambahkan kategori.',
      ).showSnackbar();
    }
  }

  void editCategory(String oldCategoryName, String newCategoryName) async {
    if (newCategoryName.isEmpty) {
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Nama kategori tidak boleh kosong.',
      ).showSnackbar();
      return;
    }

    if (oldCategoryName == newCategoryName) {
      const CustomSnackbar(
        success: false,
        title: 'Info',
        message: 'Nama kategori tidak berubah.',
      ).showSnackbar();
      return;
    }

    try {
      final toolsRef = FirebaseFirestore.instance.collection('tools');
      final oldCategoryDocRef = toolsRef.doc(oldCategoryName);
      final newCategoryDocRef = toolsRef.doc(newCategoryName);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(oldCategoryDocRef);
        if (!snapshot.exists) {
          throw Exception('Dokumen kategori tidak ditemukan!');
        }

        Map<String, dynamic>? oldCategoryData =
            snapshot.data() as Map<String, dynamic>;

        // Set data di dokumen baru dengan data lama
        transaction.set(newCategoryDocRef, oldCategoryData);

        // Pastikan data lama dihapus
        transaction.delete(oldCategoryDocRef);
      });

      // Remove the old category data from toolsData and categorizedTools
      toolsData.remove(oldCategoryName);
      categorizedTools.remove(oldCategoryName);

      // Reload category data setelah update
      await fetchTools();
      categoryName.value = ''; // Reset pilihan kategori

      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Kategori berhasil diubah.',
      ).showSnackbar();
    } catch (e) {
      log.e('Error editing category: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal mengubah kategori.',
      ).showSnackbar();
    }
  }

  void deleteCategory(String delCategoryName) async {
    if (delCategoryName.isEmpty) {
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Pilih kategori terlebih dahulu.',
      ).showSnackbar();
      return;
    }

    try {
      final toolsRef = FirebaseFirestore.instance.collection('tools');
      final categoryDocRef = toolsRef.doc(delCategoryName);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(categoryDocRef);
        if (!snapshot.exists) {
          throw Exception('Dokumen kategori tidak ditemukan!');
        }

        // Hapus dokumen kategori
        transaction.delete(categoryDocRef);
      });

      // Remove the category data from toolsData and categorizedTools
      toolsData.remove(delCategoryName);
      categorizedTools.remove(delCategoryName);

      categoryName.value = ''; // Reset pilihan kategori
      Get.back();

      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Kategori berhasil dihapus.',
      ).showSnackbar();

      await fetchTools(); // Reload data kategori setelah penghapusan
    } catch (e) {
      log.e('Error deleting category: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal menghapus kategori.',
      ).showSnackbar();
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
      final toolIndex = categorizedTools[categoryName]?.indexWhere(
        (tool) => tool['id'] == toolsId,
      );

      if (toolIndex == null || toolIndex == -1) {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Komponen tidak ditemukan.',
        ).showSnackbar();
        return;
      }

      final selectedTool = categorizedTools[categoryName]![toolIndex];
      String name = selectedTool['name'];
      String description = selectedTool['description'];
      String amount = selectedTool['tStock'].toString();

      // Hapus tools
      await FirebaseFirestore.instance
          .collection('tools')
          .doc(categoryName)
          .update({
        toolsId: FieldValue.delete(),
      });

      await _logHistoryActivity(name, description, amount, categoryName);

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
  void increment(String toolsId) {
    // Find the selected tools based on toolsId
    final selectedToolsIndex = tools.indexWhere(
      (tools) => tools['id'] == toolsId,
    );

    if (selectedToolsIndex != -1) {
      int currentStock = tools[selectedToolsIndex]['selectedStock'] ?? 1;
      int availableStock = tools[selectedToolsIndex]['stock'];

      if (currentStock < availableStock) {
        tools[selectedToolsIndex]['selectedStock'] = currentStock + 1;
        stockController.text =
            tools[selectedToolsIndex]['selectedStock'].toString();
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

  void decrement(String toolsId) {
    final selectedToolsIndex = tools.indexWhere(
      (tools) => tools['id'] == toolsId,
    );

    if (selectedToolsIndex != -1) {
      int currentStock = tools[selectedToolsIndex]['selectedStock'] ?? 1;

      if (currentStock > 1) {
        tools[selectedToolsIndex]['selectedStock'] = currentStock - 1;
        stockController.text =
            tools[selectedToolsIndex]['selectedStock'].toString();
      }
    }
  }

  void onGetToolsClicked(String categoryName, String toolsId) async {
    try {
      final selectedToolsIndex = tools.indexWhere(
        (tool) => tool['id'] == toolsId,
      );

      if (selectedToolsIndex != -1) {
        int selectedStock = tools[selectedToolsIndex]['selectedStock'] ?? 1;
        int availableStock = tools[selectedToolsIndex]['stock'] ?? 0;

        if (selectedStock > 0) {
          int newStock = availableStock - selectedStock;

          DocumentReference toolsRef =
              FirebaseFirestore.instance.collection('tools').doc(categoryName);

          if (newStock <= 0) {
            await toolsRef.update({
              '$categoryName.$toolsId': FieldValue.delete(),
              '$categoryName.$toolsId.deleteAt': FieldValue.serverTimestamp(),
            });

            tools.removeAt(selectedToolsIndex);
            filteredTools.removeWhere((tools) => tools['id'] == toolsId);

            onDeleteToolsClicked(categoryName, toolsId);
          }
          if (newStock > 0) {
            await toolsRef.update({
              '$categoryName.$toolsId.stock': newStock,
              '$categoryName.$toolsId.updateAt': FieldValue.serverTimestamp(),
            });

            tools[selectedToolsIndex]['stock'] = newStock;
            tools[selectedToolsIndex]['selectedStock'] = 0;
            filteredTools[selectedToolsIndex]['stock'] = newStock;
            filteredTools[selectedToolsIndex]['selectedStock'] = 0;

            Get.back();
            const CustomSnackbar(
              success: true,
              title: 'Berhasil',
              message: 'Komponen berhasil diambil.',
            ).showSnackbar();
          }

          await fetchTools();
        } else {
          const CustomSnackbar(
            success: false,
            title: 'Gagal',
            message: 'Stok yang diambil tidak valid.',
          ).showSnackbar();
          Get.back();
        }
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Gagal',
          message: 'Komponen tidak ditemukan.',
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
    String name,
    String description,
    String amount,
    String category,
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
          'xName': name,
          'xDescription': description,
          'xAmount': amount,
          'xLocation': "Kategori $category",
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
