import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/components/views/list_components_view.dart';

import '../../../utils/logging.dart';

class GetComponentsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList listRackNames = <String>[].obs;
  RxList listLevels = <String>[].obs;
  RxString rackName = ''.obs;
  RxMap levelData = <String, Map<String, dynamic>>{}.obs;
  RxBool isLoadingLevels = false.obs;

  TextEditingController customLevelController = TextEditingController();
  TextEditingController customRackController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchRackNames();
    onChangedRackNames('Rak 1');
  }

  void onChangedRackNames(String? value) {
    if (value != null && value.isNotEmpty) {
      rackName.value = value;
      listLevels.clear();
      levelData.clear();
      fetchLevelByRack(value);
    }
  }

  void fetchRackNames() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('components').get();

      List<String> rackNamesList =
          querySnapshot.docs.map((doc) => doc.id).toList();

      log.i("Fetched Rack Names: $rackNamesList");

      listRackNames.assignAll(rackNamesList);
    } catch (e) {
      log.e("Error fetching rack names: $e");
    }
  }

  void fetchLevelByRack(String selectedRackName) async {
    try {
      isLoadingLevels.value = true;

      DocumentSnapshot rackDoc =
          await _firestore.collection('components').doc(selectedRackName).get();

      if (rackDoc.exists) {
        Map<String, dynamic> data = rackDoc.data() as Map<String, dynamic>;

        Map<String, Map<String, dynamic>> levelsData = {};
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            levelsData[key] = value;
          }
        });

        List<String> levels = levelsData.keys.toList();
        levels.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

        log.i("Fetched and Sorted Levels for $selectedRackName: $levels");

        listLevels.assignAll(levels);
        levelData.value = levelsData;
      } else {
        log.e("Rack document does not exist");
        listLevels.clear();
        levelData.clear();
      }

      isLoadingLevels.value = false;
    } catch (e) {
      isLoadingLevels.value = false;
      log.e("Error fetching levels: $e");
    }
  }

  void onLevelClicked(String rackName, String levelName) {
    Map<String, dynamic> selectedLevelData = levelData[levelName] ?? {};

    Get.to(
      () => const ListComponentsView(),
      arguments: {
        "isGetComponent": true,
        "rackName": rackName,
        "levelName": levelName,
        "levelData": selectedLevelData, // Pass level data to the next view
      },
    );
  }
}
