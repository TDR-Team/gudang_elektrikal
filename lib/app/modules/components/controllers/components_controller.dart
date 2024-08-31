import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/styles/colors.dart';
import '../../../common/theme/font.dart';
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
  TextEditingController customRackController = TextEditingController();

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

  void addRack() async {
    try {
      // Fetch existing racks from Firestore
      QuerySnapshot snapshot = await _firestore.collection('components').get();
      List<String> existingRackNames =
          snapshot.docs.map((doc) => doc.id).toList();

      // Extract rack numbers from existing rack names
      List<int> rackNumbers = existingRackNames
          .map((name) {
            final match = RegExp(r'rack_(\d+)').firstMatch(name);
            return match != null ? int.tryParse(match.group(1) ?? '') : null;
          })
          .where((number) => number != null)
          .cast<int>()
          .toList();

      // Determine the next available rack number
      int nextRackNumber = rackNumbers.isNotEmpty
          ? rackNumbers.reduce((a, b) => a > b ? a : b) + 1
          : 1;

      // Convert the new rack number to Firestore format
      String firestoreRackName = 'rack_$nextRackNumber';

      // Check if the rack already exists
      if (existingRackNames.contains(firestoreRackName)) {
        Get.snackbar(
          "Gagal",
          "Rak dengan nomor $nextRackNumber sudah ada",
        );
        return;
      }

      // Add the new rack to Firestore
      await _firestore.collection('components').doc(firestoreRackName).set({});

      // Update the UI to reflect the new rack
      String displayRackName = 'Rak $nextRackNumber'; // For UI display
      rackNames.add(displayRackName);
      rackNames.sort(); // Optional: Sort the list if you want it ordered
      convertedToOriginalMap[displayRackName] = firestoreRackName;

      Get.back(); // Close the add rack dialog (if applicable)
      customRackController.clear();
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Rak Berhasil Ditambahkan',
      ).showSnackbar();
    } catch (e) {
      log.e("Error adding rack: $e");
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menambah Rak',
      ).showSnackbar();
    }
  }

  void onEditRack(String oldRackName, String newRackName) {
    if (newRackName.isEmpty) {
      Get.snackbar('Error', 'Nama rak tidak boleh kosong.');
      return;
    }

    if (oldRackName == newRackName) {
      Get.snackbar('Info', 'Nama rak tidak berubah.');
      return;
    }

    // Simulate updating rack name in a database or data source
    final index = rackNames.indexOf(oldRackName);
    if (index != -1) {
      rackNames[index] = newRackName;
      // Update the data source (e.g., Firestore)
      // Example:
      // firestore.collection('racks').doc(oldRackName).update({'name': newRackName});

      // Notify user
      Get.snackbar('Sukses', 'Nama rak berhasil diubah.');
    } else {
      Get.snackbar('Error', 'Rak tidak ditemukan.');
    }
  }

  void onDeleteRack(String inputRackName) async {
    if (inputRackName.isEmpty) {
      Get.snackbar('Error', 'Pilih rak terlebih dahulu.');
      return;
    }

    // Confirm deletion
    Get.defaultDialog(
      title: 'Konfirmasi Hapus',
      content: Text(
        'Apakah Anda yakin ingin menghapus rak ini?',
        style: semiBoldText14,
      ),
      confirm: TextButton(
        onPressed: () async {
          try {
            // Get the original rack name from the converted map
            String? originalRackName = convertedToOriginalMap[inputRackName];

            if (originalRackName != null) {
              // Log the names to debug
              print(
                  'Attempting to delete rack with original name: $originalRackName');

              // Delete the document from Firestore
              await _firestore
                  .collection('components')
                  .doc(originalRackName)
                  .delete();

              // Update the UI
              rackNames.remove(inputRackName);
              convertedToOriginalMap.remove(inputRackName);

              // Clear selected rack and levels if needed
              if (inputRackName == rackName.value) {
                rackName.value = '';
                listLevels.clear();
                levelData.clear();
              }

              Get.snackbar('Sukses', 'Rak berhasil dihapus.');
              Get.back(); // Close the confirmation dialog
            } else {
              Get.snackbar('Error', 'Rak tidak ditemukan.');
            }
          } catch (e) {
            print('Error deleting rack: $e'); // Log error for debugging
            Get.snackbar('Error', 'Gagal menghapus rak.');
          } finally {
            Get.back(); // Close the confirmation dialog
          }
        },
        child: Text(
          'Hapus',
          style: semiBoldText14.copyWith(color: kColorScheme.error),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(), // Close the dialog without doing anything
        child: Text(
          'Batal',
          style: semiBoldText14,
        ),
      ),
    );
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
