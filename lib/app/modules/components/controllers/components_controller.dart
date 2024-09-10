import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../views/list_components_view.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../utils/logging.dart';

class ComponentsController extends GetxController {
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
  }

  //RACK (RAK)
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

  void addRack() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('components').get();
      List<String> existingRackNames =
          snapshot.docs.map((doc) => doc.id).toList();

      List<int> rackNumbers = existingRackNames
          .map((name) {
            final match = RegExp(r'Rak (\d+)').firstMatch(name);
            return match != null ? int.tryParse(match.group(1) ?? '') : null;
          })
          .where((number) => number != null)
          .cast<int>()
          .toList();

      int nextRackNumber = rackNumbers.isNotEmpty
          ? rackNumbers.reduce((a, b) => a > b ? a : b) + 1
          : 1;

      String newRackName = 'Rak $nextRackNumber';

      if (existingRackNames.contains(newRackName)) {
        Get.snackbar(
          "Gagal",
          "Rak dengan nomor $nextRackNumber sudah ada",
        );
        return;
      }

      await _firestore.collection('components').doc(newRackName).set({});

      listRackNames.add(newRackName);

      listRackNames.sort((a, b) {
        final numA = int.tryParse(RegExp(r'\d+').allMatches(a).toString()) ?? 0;
        final numB = int.tryParse(RegExp(r'\d+').allMatches(b).toString()) ?? 0;
        return numA.compareTo(numB);
      });

      rackName.value = newRackName;
      listLevels.clear();
      levelData.clear();

      fetchLevelByRack(newRackName);

      onChangedRackNames(newRackName);

      Get.back();
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

  void onEditRack(String oldRackName, String newRackNumber) async {
    if (newRackNumber.isEmpty) {
      Get.snackbar('Error', 'Nomor rak tidak boleh kosong.');
      return;
    }

    final oldRackNumberMatch = RegExp(r'Rak (\d+)').firstMatch(oldRackName);
    final newRackName = 'Rak $newRackNumber';

    if (oldRackNumberMatch == null) {
      Get.snackbar('Error', 'Nama rak lama tidak valid.');
      return;
    }

    final oldRackNumber = oldRackNumberMatch.group(1);

    if (oldRackNumber == newRackNumber) {
      Get.snackbar('Info', 'Nomor rak tidak berubah.');
      return;
    }

    if (listRackNames.contains(newRackName)) {
      Get.snackbar('Error', 'Rak dengan nomor $newRackNumber sudah ada.');
      return;
    }

    try {
      DocumentReference oldRackDocRef =
          FirebaseFirestore.instance.collection('components').doc(oldRackName);

      DocumentReference newRackDocRef =
          FirebaseFirestore.instance.collection('components').doc(newRackName);

      // Start Firestore transaction to update the rack name
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(oldRackDocRef);
        if (!snapshot.exists) {
          throw Exception('Dokumen rak tidak ditemukan!');
        }

        Map<String, dynamic>? oldRackData =
            snapshot.data() as Map<String, dynamic>;

        transaction.set(newRackDocRef, oldRackData);

        transaction.delete(oldRackDocRef);
      });

      int index = listRackNames.indexOf(oldRackName);
      if (index != -1) {
        listRackNames[index] = newRackName;

        listRackNames.sort((a, b) {
          final numA =
              int.tryParse(RegExp(r'\d+').firstMatch(a)?.group(0) ?? '0') ?? 0;
          final numB =
              int.tryParse(RegExp(r'\d+').firstMatch(b)?.group(0) ?? '0') ?? 0;
          return numA.compareTo(numB);
        });

        listLevels.clear();
        levelData.clear();

        rackName.value = newRackName;

        fetchLevelByRack(newRackName);

        Get.snackbar('Sukses', 'Nomor rak berhasil diubah.');
      } else {
        Get.snackbar('Error', 'Rak tidak ditemukan.');
      }

      Get.back();
    } catch (e) {
      log.e('Error editing rack: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Mengubah Nomor Rak',
      ).showSnackbar();
    }
  }

  void onDeleteRack(String inputRackName) async {
    if (inputRackName.isEmpty) {
      Get.snackbar('Error', 'Pilih rak terlebih dahulu.');
      return;
    }
    try {
      DocumentReference rackDocRef = FirebaseFirestore.instance
          .collection('components')
          .doc(inputRackName);

      await rackDocRef.delete();

      rackName.value = '';
      Get.back();
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Rak Berhasil Dihapus',
      ).showSnackbar();

      fetchRackNames();
      log.i('rack name isi: ${rackName.value}');
      onChangedRackNames(rackName.value);
    } catch (e) {
      log.i('Error deleting level: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Laci',
      ).showSnackbar();
    }
  }

  //LEVEL (LACI)
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

  void addLevel() async {
    try {
      DocumentSnapshot rackDoc = await FirebaseFirestore.instance
          .collection('components')
          .doc(rackName.value)
          .get();

      if (!rackDoc.exists) {
        Get.snackbar(
          "Error",
          "Rak tidak ditemukan.",
        );
        return;
      }

      Map<String, dynamic> existingLevels =
          rackDoc.data() as Map<String, dynamic>;

      List<String> levelKeys = existingLevels.keys.toList();
      int nextLevelNumber = 1;

      if (levelKeys.isNotEmpty) {
        List<int> levelNumbers = [];
        for (var key in levelKeys) {
          final int? levelNumber = int.tryParse(key);
          if (levelNumber != null) {
            levelNumbers.add(levelNumber);
          }
        }

        if (levelNumbers.isNotEmpty) {
          nextLevelNumber = levelNumbers.reduce((a, b) => a > b ? a : b) + 1;
        }
      }

      String newLevelName = nextLevelNumber.toString();

      await FirebaseFirestore.instance
          .collection('components')
          .doc(rackName.value)
          .set({newLevelName: {}}, SetOptions(merge: true));

      listLevels.add(newLevelName);
      listLevels.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      levelData[newLevelName] = {};

      Get.back();
      customLevelController.clear();
      Get.snackbar(
        "Berhasil",
        "Laci berhasil ditambahkan.",
      );
    } catch (e) {
      // log.e("Error adding level: $e");
      // Get.snackbar(
      //   "Error",
      //   "Gagal menambah laci",
      // );
      Get.snackbar(
        "Berhasil",
        "Laci berhasil ditambahkan.",
      );
    }
  }

  Future<void> onDeleteLevel(String selectedRackName, String levelName) async {
    try {
      DocumentReference rackDocRef = FirebaseFirestore.instance
          .collection('components')
          .doc(selectedRackName);

      await rackDocRef.update({levelName: FieldValue.delete()});

      Get.back();
      const CustomSnackbar(
        success: true,
        title: 'Berhasil',
        message: 'Laci Berhasil Dihapus',
      ).showSnackbar();

      fetchLevelByRack(selectedRackName);
    } catch (e) {
      log.i('Error deleting level: $e');
      const CustomSnackbar(
        success: false,
        title: 'Gagal',
        message: 'Gagal Menghapus Laci',
      ).showSnackbar();
    }
  }

  //ROUTES
  void onLevelClicked(String rackName, String levelName) {
    Map<String, dynamic> selectedLevelData = levelData[levelName] ?? {};

    Get.to(
      () => const ListComponentsView(),
      arguments: {
        "rackName": rackName,
        "levelName": levelName,
        "levelData": selectedLevelData,
      },
    );
  }
}
