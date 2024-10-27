import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/common/helpers/schedule_daily_push_notif_helper.dart';
import 'package:gudang_elektrikal/app/modules/components/views/add_components_view.dart';
import 'package:gudang_elektrikal/app/modules/components/views/edit_components_view.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/logging.dart';
import '../../../widgets/custom_snackbar.dart';

class ListComponentsController extends GetxController {
  final String levelName = Get.arguments['levelName'];
  final String rackName = Get.arguments['rackName'];
  final bool isGetComponent = Get.arguments['isGetComponent'] ?? false;

  TextEditingController stockController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> components = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredComponents =
      <Map<String, dynamic>>[].obs;

  FocusNode stockFocusNode = FocusNode();
  RxInt stock = 1.obs;

  String? userName;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
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

        // Check for low stock and trigger notification if conditions are met
        for (var component in filteredComponents) {
          int stock = component['stock'];
          if (stock > 0 && stock <= 3) {
            ScheduleDailyPuhNotifHelper.scheduleDailyPushNotifHelper(
                ' ${component['name']}');
          }
        }
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
      String componentsId, bool isGetComponent) async {
    try {
      final componentsDoc = await FirebaseFirestore.instance
          .collection('tools')
          .doc(rackName)
          .get();
      final componentsMap = componentsDoc.data();
      final componentsData =
          componentsMap?[componentsId] as Map<String, dynamic>? ?? {};
      DocumentReference rackRef =
          FirebaseFirestore.instance.collection('components').doc(rackName);

      await rackRef.update({'$levelName.$componentsId': FieldValue.delete()});

      final logData = {
        componentsId: componentsData,
      };

      await _logHistoryActivity(logData);

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
          title: 'Sudah Maksimal',
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

          debugPrint(
              'stock sisa: ${filteredComponents[selectedComponentIndex]['stock']}');

          if (filteredComponents[selectedComponentIndex]['stock'] > 0 &&
              filteredComponents[selectedComponentIndex]['stock'] <= 3) {
            ScheduleDailyPuhNotifHelper.scheduleDailyPushNotifHelper(
                ' ${filteredComponents[selectedComponentIndex]}');
          }
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
    Map<String, dynamic> componentsData,
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
          'itemType': "components",
          'actionType': "delete",
          'itemData': componentsData,
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
