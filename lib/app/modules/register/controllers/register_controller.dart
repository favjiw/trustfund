import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exceptions.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  /// Raw date for the API (YYYY-MM-DD), separate from the display format.
  String _apiDateOfBirth = '';

  AuthService get _auth => Get.find<AuthService>();

  Future<void> pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      birthDateController.text = _formatDisplayDate(picked);
      _apiDateOfBirth = _formatApiDate(picked);
    }
  }

  /// Display format: dd/mm/yyyy
  String _formatDisplayDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd/$mm/${date.year}';
  }

  /// API format: YYYY-MM-DD
  String _formatApiDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  /// Normalises a user-entered phone number into the `+62xxxx` format the
  /// backend expects.
  ///
  /// The [PhoneField] shows a `+62` prefix decoratively only, so the user
  /// types just the national part (e.g. `82117778311` or `082117778311`).
  /// Accepts input already prefixed with `+62`, `62`, or a leading `0`.
  /// Returns `null` when the remaining number is not plausibly valid.
  String? _normalizePhone(String raw) {
    var s = raw.replaceAll(RegExp(r'[\s\-()]'), '');
    if (s.startsWith('+62')) {
      s = s.substring(3);
    } else if (s.startsWith('62')) {
      s = s.substring(2);
    } else if (s.startsWith('0')) {
      s = s.substring(1);
    }
    if (!RegExp(r'^\d{8,13}$').hasMatch(s)) return null;
    return '+62$s';
  }

  Future<void> register() async {
    // ── Client-side validation ────────────────────────────────────────
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        _apiDateOfBirth.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Lengkapi semua data terlebih dahulu.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError('Format email tidak valid.');
      return;
    }

    if (password.length < 6) {
      _showError('Kata sandi minimal 6 karakter.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Kata sandi dan konfirmasi tidak cocok.');
      return;
    }

    final normalizedPhone = _normalizePhone(phone);
    if (normalizedPhone == null) {
      _showError('Nomor telepon tidak valid. Contoh: 82117778311.');
      return;
    }

    // ── API call ──────────────────────────────────────────────────────
    isLoading.value = true;
    try {
      await _auth.register(
        name: name,
        email: email,
        dateOfBirth: _apiDateOfBirth,
        phoneNumber: normalizedPhone,
        password: password,
        confirmPassword: confirmPassword,
      );

      Get.back(); // Return to login page.
      _showSuccess('Registrasi berhasil! Silakan masuk.');
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Terjadi kesalahan. Coba lagi nanti.');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.back();

  // ── Feedback helpers ────────────────────────────────────────────────

  void _showError(String message) {
    Get.snackbar(
      'Gagal',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.danger,
      colorText: AppColors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }

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
