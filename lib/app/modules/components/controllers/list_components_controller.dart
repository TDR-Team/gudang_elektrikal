import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/modules/components/views/add_components_view.dart';
import 'package:gudang_elektrikal/app/modules/components/views/edit_components_view.dart';
import '../../../widgets/custom_snackbar.dart';

class ListComponentsController extends GetxController {
  final String levelName = Get.arguments['levelName'];
  final String rackName = Get.arguments['rackName'];

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> components = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredComponents =
      <Map<String, dynamic>>[].obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComponents();
    // FocusManager.instance.primaryFocus!.unfocus();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    searchController.clear();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

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
          };
        }).toList();

        filteredComponents.value =
            components.value; // Initialize with all components
      } else {
        components.value = [];
        filteredComponents.value = [];
      }
    } catch (e) {
      print('Error fetching components: $e');
      components.value = [];
      filteredComponents.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    filteredComponents.value = components.where((component) {
      final name = component['name'].toLowerCase();
      return name.contains(query);
    }).toList();
  }

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

  Future<void> onDeleteComponentClicked(String componentId) async {
    try {
      DocumentReference rackDocRef =
          FirebaseFirestore.instance.collection('components').doc(rackName);

      await rackDocRef.update({'$levelName.$componentId': FieldValue.delete()});

      Get.back();
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Komponen Berhasil Dihapus',
      ).showSnackbar();

      await fetchComponents();
    } catch (e) {
      print('Error deleting component: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Komponen',
      ).showSnackbar();
    }
  }
}
