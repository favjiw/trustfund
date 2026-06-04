import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  /// The single demo account accepted by this UI build.
  static const String _validEmail = 'gilangns@gmail.com';
  static const String _validPassword = 'gilang123';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Lengkapi email dan kata sandi terlebih dahulu.');
      return;
    }

    if (email.toLowerCase() != _validEmail || password != _validPassword) {
      _showError('Email atau kata sandi salah.');
      return;
    }

    // Valid credentials: enter the main app shell, replacing the auth stack.
    Get.offAllNamed(Routes.BOTNAVBAR);
  }

  void _showError(String message) {
    Get.snackbar(
      'Gagal masuk',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.danger,
      colorText: AppColors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
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
