import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void resetPassword() => Get.toNamed(Routes.OTP_VERIFICATION);

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
