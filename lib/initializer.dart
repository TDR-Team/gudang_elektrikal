import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/auth/auth_controller.dart';
import 'package:gudang_elektrikal/app/modules/network/controller/network_controller.dart';
import 'package:gudang_elektrikal/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;

class Initializer {
  static Future<void> init() async {
    try {
      Get.put<NetworkController>(
        NetworkController(),
        permanent: true,
      );
      Get.put<AuthController>(
        AuthController(),
      );
      tz.initializeTimeZones();
      initializeDateFormatting();
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
