import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    // UI-only build: no backend is wired up. Navigate to the main app shell
    // (bottom navigation), replacing the auth stack.
    Get.offAllNamed(Routes.BOTNAVBAR);
  }

  void goToRegister() => Get.toNamed(Routes.REGISTER);
  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
