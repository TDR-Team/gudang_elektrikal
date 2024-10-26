import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/login/controllers/forgot_password_controller.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
