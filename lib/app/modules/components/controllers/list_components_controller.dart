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

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComponents();
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

  void onAddComponentClicked() {
    Get.to(
      () => const AddComponentsView(),
      arguments: {
        "rackName": rackName,
        "levelName": levelName,
        // Pass level data to the next view
      },
    )?.then((value) async => await fetchComponents());
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
        "component": selectedComponent, // Pass the selected component data
        "componentId": componentId, // Pass the component ID
      },
    )?.then((value) async => await fetchComponents());
  }

  Future<void> onDeleteComponentClicked(String componentId) async {
    try {
      // Reference to the rack document
      DocumentReference rackDocRef =
          FirebaseFirestore.instance.collection('components').doc(rackName);

      // Update the rack document to remove the component
      await rackDocRef.update({'$levelName.$componentId': FieldValue.delete()});

      Get.back();
      // Show success snackbar
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Komponen Berhasil Dihapus',
      ).showSnackbar();

      // Update the component list
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
