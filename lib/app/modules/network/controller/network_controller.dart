import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  bool isSnackbarShown = false;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (!isSnackbarShown) {
        Get.rawSnackbar(
          backgroundColor: Colors.red,
          messageText: const Text(
            'Tidak ada internet',
            style: TextStyle(color: Colors.white),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
        );
        isSnackbarShown = true;
      }
    } else {
      if (isSnackbarShown) {
        Get.closeCurrentSnackbar();
        Get.rawSnackbar(
          backgroundColor: Colors.green,
          messageText: const Text(
            'Terhubung kembali',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: const Duration(seconds: 3),
        );
        isSnackbarShown = false;
      }
    }
  }
}
