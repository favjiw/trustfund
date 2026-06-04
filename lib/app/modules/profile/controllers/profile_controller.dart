import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';

class ProfileController extends GetxController {
  static const int _savedTabIndex = 2;

  final String name = 'Gilang';
  final String email = 'gilangns@gmail.com';
  final String avatarUrl =
      'https://randomuser.me/api/portraits/men/75.jpg';
  final bool verified = true;

  final String totalDonationLabel = 'Rp12.45M';
  final String supportedCount = '14';
  final String livesHelped = '450+';

  final String appVersion = 'TrustFund v1.0.0';

  /// Jump to the existing Saved tab from the profile shortcut.
  void goToSaved() {
    if (Get.isRegistered<BotNavBarController>()) {
      Get.find<BotNavBarController>().changePage(_savedTabIndex);
    }
  }

  void logout() => Get.offAllNamed(Routes.LOGIN);
}
