import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/modules/components/views/add_components_view.dart';
import 'package:gudang_elektrikal/app/modules/components/views/edit_components_view.dart';
import '../../../utils/logging.dart';
import '../../../widgets/custom_snackbar.dart';

class ListComponentsController extends GetxController {
  final String levelName = Get.arguments['levelName'];
  final String rackName = Get.arguments['rackName'];
  final bool isGetComponent = Get.arguments['isGetComponent'] ?? false;

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> components = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredComponents =
      <Map<String, dynamic>>[].obs;

  FocusNode stockFocusNode = FocusNode();
  RxInt stock = 1.obs;

  TextEditingController stockController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComponents();
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

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    filteredComponents.value = components.where((component) {
      final name = component['name'].toLowerCase();
      return name.contains(query);
    }).toList();
  }

  // COMPONENT
  Future<void> fetchComponents() async {
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
            'selectedStock': 1,
          };
        }).toList();

        // ignore: invalid_use_of_protected_member
        filteredComponents.value = components.value;
      } else {
        components.value = [];
        filteredComponents.value = [];
      }
    } catch (e) {
      log.e('Error fetching components: $e');
      components.value = [];
      filteredComponents.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void onEditComponentClicked(String componentId) {
    final selectedComponent = components.firstWhere(
      (component) => component['id'] == componentId,
    );

    Get.to(
      () => const EditComponentsView(),
      arguments: {
        "rackName": rackName,
        "levelName": levelName,
        "component": selectedComponent,
        "componentId": componentId,
      },
    )?.then((value) async => await fetchComponents());
  }

  Future<void> onDeleteComponentClicked(
      String componentId, bool isGetComponent) async {
    try {
      DocumentReference rackDocRef =
          FirebaseFirestore.instance.collection('components').doc(rackName);

      await rackDocRef.update({'$levelName.$componentId': FieldValue.delete()});

      Get.back();
      CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: isGetComponent
            ? 'Komponen berhasil diambil dan stok habis.'
            : 'Komponen Berhasil Dihapus',
      ).showSnackbar();

      await fetchComponents();
    } catch (e) {
      log.e('Error deleting component: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Komponen',
      ).showSnackbar();
    }
  }

  // GET COMPONENT
  void increment(String componentId) {
    // Find the selected component based on componentId
    final selectedComponentIndex = components.indexWhere(
      (component) => component['id'] == componentId,
    );

    if (selectedComponentIndex != -1) {
      int currentStock =
          components[selectedComponentIndex]['selectedStock'] ?? 1;
      int availableStock = components[selectedComponentIndex]['stock'];

      if (currentStock < availableStock) {
        components[selectedComponentIndex]['selectedStock'] = currentStock + 1;
        stockController.text =
            components[selectedComponentIndex]['selectedStock'].toString();
      } else {
        const CustomSnackbar(
          success: false,
          title: 'Sudah Maximal',
          message:
              'Tidak dapat mengambil komponen melebihi batas stok yang tersedia',
        ).showSnackbar();
      }
    }
  }

  void decrement(String componentId) {
    final selectedComponentIndex = components.indexWhere(
      (component) => component['id'] == componentId,
    );

    if (selectedComponentIndex != -1) {
      int currentStock =
          components[selectedComponentIndex]['selectedStock'] ?? 1;

      if (currentStock > 1) {
        components[selectedComponentIndex]['selectedStock'] = currentStock - 1;
        stockController.text =
            components[selectedComponentIndex]['selectedStock'].toString();
      }
    }
  }

  void onGetComponentClicked(String componentId) async {
    try {
      final selectedComponentIndex = components.indexWhere(
        (component) => component['id'] == componentId,
      );

      if (selectedComponentIndex != -1) {
        int selectedStock =
            components[selectedComponentIndex]['selectedStock'] ?? 1;
        int availableStock = components[selectedComponentIndex]['stock'] ?? 0;

        if (selectedStock > 0) {
          int newStock = availableStock - selectedStock;

          DocumentReference componentRef =
              FirebaseFirestore.instance.collection('components').doc(rackName);

          if (newStock <= 0) {
            await componentRef.update({
              '$levelName.$componentId': FieldValue.delete(),
              '$levelName.$componentId.deleteAt': FieldValue.serverTimestamp(),
            });

            components.removeAt(selectedComponentIndex);
            filteredComponents
                .removeWhere((component) => component['id'] == componentId);

            onDeleteComponentClicked(
              componentId,
              isGetComponent,
            );
          }
          if (newStock > 0) {
            await componentRef.update({
              '$levelName.$componentId.stock': newStock,
              '$levelName.$componentId.updateAt': FieldValue.serverTimestamp(),
            });

            components[selectedComponentIndex]['stock'] = newStock;
            components[selectedComponentIndex]['selectedStock'] = 0;
            filteredComponents[selectedComponentIndex]['stock'] = newStock;
            filteredComponents[selectedComponentIndex]['selectedStock'] = 0;

            Get.back();
            const CustomSnackbar(
              success: true,
              title: 'Berhasil',
              message: 'Komponen berhasil diambil.',
            ).showSnackbar();
          }

          await fetchComponents();
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
      log.e('Error getting component: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal mengambil komponen.',
      ).showSnackbar();
      Get.back();
    }
  }

  // ROUTES
  void onAddComponentClicked() {
    Get.to(
      () => const AddComponentsView(),
      arguments: {
        "rackName": rackName,
        "levelName": levelName,
      },
    )?.then((value) async {
      searchController.clear();
      await fetchComponents();
    });
  }
}
