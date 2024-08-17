import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/modules/components/views/list_components_view.dart';
import 'dart:math' as math; // Import math library with alias

class ComponentsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var rackNames = <String>[].obs;
  var listLevels = <String>[].obs;
  var rackName = ''.obs;
  var levelData =
      <String, Map<String, dynamic>>{}.obs; // New observable for level data
  var isLoadingLevels = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRackNames();
  }

  void fetchRackNames() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('components').get();

      // Assuming that 'components' collection has documents representing rack names
      List<String> names = querySnapshot.docs.map((doc) => doc.id).toList();

      // For debugging
      print("Fetched Rack Names: $names");

      rackNames.assignAll(names);
    } catch (e) {
      print("Error fetching rack names: $e");
    }
  }

  void fetchRackLevels(String selectedRackName) async {
    try {
      isLoadingLevels.value = true;

      // Fetch the document for the selected rack
      DocumentSnapshot rackDoc =
          await _firestore.collection('components').doc(selectedRackName).get();

      if (rackDoc.exists) {
        // Extract levels from the document data
        Map<String, dynamic> data = rackDoc.data() as Map<String, dynamic>;

        // Filter and cast the levels correctly
        Map<String, Map<String, dynamic>> levelsData = {};
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            levelsData[key] = value;
          }
        });

        List<String> levels = levelsData.keys.toList();

        // For debugging
        print("Fetched Levels for $selectedRackName: $levels");

        listLevels.assignAll(levels);
        levelData.value = levelsData; // Assign the cast data
      } else {
        print("Rack document does not exist");
        listLevels.clear();
        levelData.clear();
      }

      isLoadingLevels.value = false;
    } catch (e) {
      isLoadingLevels.value = false;
      print("Error fetching levels: $e");
    }
  }

  void onChangedRackNames(String? value) {
    if (value != null && value.isNotEmpty) {
      rackName.value = value;
      listLevels.clear(); // Clear previous levels
      levelData.clear(); // Clear previous level data
      fetchRackLevels(value);
    }
  }

  void addLevel() async {
    try {
      // Get the current highest level number (if any)
      int highestLevel = 0;
      if (listLevels.isNotEmpty) {
        highestLevel = listLevels
            .map(int.parse)
            .reduce(math.max); // Efficiently find the highest level
      }

      // Generate the new level name (increment by 1)
      String newLevelName = (highestLevel + 1).toString();

      // Add the new level to the rack document
      await FirebaseFirestore.instance
          .collection('components')
          .doc(rackName.value)
          .set({newLevelName: {}}, SetOptions(merge: true));

      // Update the UI to reflect the new level
      listLevels.add(newLevelName);
      levelData[newLevelName] =
          {}; // Create an empty entry for the new level data

      Get.back(); // Close the add level dialog (if applicable)
    } catch (e) {
      print("Error adding level: $e");
      Get.snackbar(
        "Error",
        "Gagal",
      );
    }
  }

  void onLevelClicked(String rackName, String levelName) {
    Map<String, dynamic> selectedLevelData = levelData[levelName] ?? {};

    Get.to(
      () => const ListComponentsView(),
      arguments: {
        "rackName": rackName,
        "levelName": levelName,
        "levelData": selectedLevelData, // Pass level data to the next view
      },
    );
  }
}
