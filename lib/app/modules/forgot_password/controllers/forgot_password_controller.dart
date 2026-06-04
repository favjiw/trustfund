import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void resetPassword() {
    final email = emailController.text.trim();
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    if (email.isEmpty || !regex.hasMatch(email)) {
      Get.snackbar('Error', 'Masukkan email yang valid', snackPosition: SnackPosition.TOP);
      return;
    }
    Get.toNamed(Routes.OTP_VERIFICATION);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
