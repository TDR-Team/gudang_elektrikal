import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/list_components_view.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../utils/logging.dart';

class ComponentsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var rackNames = <String>[].obs;
  var listLevels = <String>[].obs;
  var rackName = ''.obs;
  var levelData = <String, Map<String, dynamic>>{}.obs;
  var isLoadingLevels = false.obs;
  final Map<String, String> convertedToOriginalMap = {};

  TextEditingController customLevelController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchRackNames();
  }

  void fetchRackNames() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('components').get();

      List<String> convertedNames = querySnapshot.docs.map((doc) {
        String originalName = doc.id; // e.g., "rack_1"

        // Convert the original name to the desired format
        String convertedName =
            originalName.replaceAll('_', ' '); // e.g., "rack 1"
        convertedName =
            convertedName.replaceFirst('rack', 'Rak'); // e.g., "Rak 1"

        // Store in the map for later lookup
        convertedToOriginalMap[convertedName] = originalName;

        return convertedName;
      }).toList();

      log.i("Fetched and Converted Rack Names: $convertedNames");

      rackNames.assignAll(convertedNames); // Assign the converted names
    } catch (e) {
      log.e("Error fetching rack names: $e");
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

        // Convert keys to a list and sort them numerically
        List<String> levels = levelsData.keys.toList();
        levels.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

        // For debugging
        log.i("Fetched and Sorted Levels for $selectedRackName: $levels");

        listLevels.assignAll(levels);
        levelData.value = levelsData; // Assign the cast data
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

  void onChangedRackNames(String? value) {
    if (value != null && value.isNotEmpty) {
      // Map the converted name back to the original name
      String? originalRackName = convertedToOriginalMap[value];

      if (originalRackName != null) {
        rackName.value = originalRackName;
        listLevels.clear(); // Clear previous levels
        levelData.clear(); // Clear previous level data
        fetchRackLevels(originalRackName);
      }
    }
  }

  void addLevel(String customLevelName) async {
    try {
      // Validate the input
      if (customLevelName.isEmpty) {
        Get.snackbar(
          "Gagal",
          "Nama laci tidak boleh kosong",
        );
        return;
      }

      // Check if the level already exists
      if (listLevels.contains(customLevelName)) {
        Get.snackbar(
          "Gagal",
          "Laci dengan nomor $customLevelName sudah ada",
        );
        return;
      }

      // Add the new level to the rack document
      await FirebaseFirestore.instance
          .collection('components')
          .doc(rackName.value)
          .set({customLevelName: {}}, SetOptions(merge: true));

      // Update the UI to reflect the new level
      listLevels.add(customLevelName);
      listLevels.sort((a, b) =>
          int.parse(a).compareTo(int.parse(b))); // Keep the list sorted
      levelData[customLevelName] =
          {}; // Create an empty entry for the new level data

      Get.back(); // Close the add level dialog (if applicable)
      customLevelController.clear();
    } catch (e) {
      log.i("Error adding level: $e");
      Get.snackbar(
        "Error",
        "Gagal menambah laci",
      );
    }
  }

  Future<void> onDeleteLevel(String selectedRackName, String levelName) async {
    try {
      DocumentReference rackDocRef = FirebaseFirestore.instance
          .collection('components')
          .doc(selectedRackName);

      // Update the rack document to remove the component
      await rackDocRef.update({levelName: FieldValue.delete()});

      Get.back();
      // Show success snackbar
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Laci Berhasil Dihapus',
      ).showSnackbar();

      // Update the component list
      fetchRackLevels(selectedRackName);
    } catch (e) {
      log.i('Error deleting level: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Laci',
      ).showSnackbar();
    }
  }

  Future<void> onEditLevel(
    String selectedRackName,
    String oldLevelName,
    String newLevelName,
  ) async {
    try {
      if (newLevelName.isEmpty) {
        Get.snackbar(
          "Gagal",
          "Nama laci tidak boleh kosong",
        );
        return;
      }

      if (listLevels.contains(newLevelName)) {
        Get.snackbar(
          "Gagal",
          "Laci dengan nomor $newLevelName sudah ada",
        );
        return;
      }

      DocumentReference rackDocRef = FirebaseFirestore.instance
          .collection('components')
          .doc(selectedRackName);

      // Get the old level data
      Map<String, dynamic>? oldLevelData = levelData[oldLevelName];

      // Update Firestore: delete the old level and add the new one
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(rackDocRef);
        if (!snapshot.exists) {
          throw Exception("Document does not exist!");
        }

        transaction.update(rackDocRef, {oldLevelName: FieldValue.delete()});
        transaction.update(rackDocRef, {newLevelName: oldLevelData ?? {}});
      });

      // Update the UI to reflect the renamed level
      listLevels.remove(oldLevelName);
      listLevels.add(newLevelName);
      listLevels.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      levelData.remove(oldLevelName);
      levelData[newLevelName] = oldLevelData ?? {};

      Get.back(); // Close the edit level dialog (if applicable)

      // Show success snackbar
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Laci Berhasil Diubah',
      ).showSnackbar();
    } catch (e) {
      log.e('Error editing level: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Mengubah Laci',
      ).showSnackbar();
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
