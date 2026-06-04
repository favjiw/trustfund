import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      birthDateController.text = _formatDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd/$mm/${date.year}';
  }

  void register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final birth = birthDateController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");

    if (name.isEmpty) {
      Get.snackbar('Error', 'Masukkan nama lengkap', snackPosition: SnackPosition.TOP);
      return;
    }
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      Get.snackbar('Error', 'Masukkan email yang valid', snackPosition: SnackPosition.TOP);
      return;
    }
    if (birth.isEmpty) {
      Get.snackbar('Error', 'Pilih tanggal lahir', snackPosition: SnackPosition.TOP);
      return;
    }
    if (phone.isEmpty) {
      Get.snackbar('Error', 'Masukkan nomor telepon', snackPosition: SnackPosition.TOP);
      return;
    }
    if (password.isEmpty || password.length < 6) {
      Get.snackbar('Error', 'Password harus minimal 6 karakter', snackPosition: SnackPosition.TOP);
      return;
    }
    if (password != confirm) {
      Get.snackbar('Error', 'Password dan konfirmasi tidak sama', snackPosition: SnackPosition.TOP);
      return;
    }

    // All validations passed - navigate to Login (as per app flow)
    Get.offAllNamed(Routes.LOGIN);
  }

  void goToLogin() => Get.offAllNamed(Routes.LOGIN);

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
