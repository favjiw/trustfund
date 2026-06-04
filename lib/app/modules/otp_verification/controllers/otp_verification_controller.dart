import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  final code = ''.obs;

  void onCodeChanged(String value) => code.value = value;

  void verify() {
    if (code.value.length != 5) {
      Get.snackbar('Error', 'Kode harus 5 digit', snackPosition: SnackPosition.TOP);
      return;
    }
    Get.toNamed(Routes.RESET_PASSWORD);
  }

  void resend() {
    // UI-only build: no backend is wired up.
  }
}
