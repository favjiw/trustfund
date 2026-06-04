import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  final code = ''.obs;

  void onCodeChanged(String value) => code.value = value;

  void verify() => Get.toNamed(Routes.RESET_PASSWORD);

  void resend() {
    // UI-only build: no backend is wired up.
  }
}
