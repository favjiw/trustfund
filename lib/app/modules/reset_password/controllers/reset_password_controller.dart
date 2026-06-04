import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void updatePassword() {
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (password.isEmpty || password.length < 6) {
      Get.snackbar('Error', 'Password harus minimal 6 karakter', snackPosition: SnackPosition.TOP);
      return;
    }
    if (password != confirm) {
      Get.snackbar('Error', 'Password dan konfirmasi tidak sama', snackPosition: SnackPosition.TOP);
      return;
    }

    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
