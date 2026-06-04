import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !_isEmailValid(email)) {
      Get.snackbar('Error', 'Masukkan email yang valid', snackPosition: SnackPosition.TOP);
      return;
    }

    if (password.isEmpty || password.length < 6) {
      Get.snackbar('Error', 'Password harus minimal 6 karakter', snackPosition: SnackPosition.TOP);
      return;
    }

    // All validations passed
    Get.offAllNamed(Routes.HOME);
  }

  bool _isEmailValid(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return regex.hasMatch(email);
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
