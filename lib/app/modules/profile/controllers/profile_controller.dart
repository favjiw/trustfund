import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';

class ProfileController extends GetxController {
  static const int _savedTabIndex = 2;

  AuthService get _auth => Get.find<AuthService>();

  UserModel? get user => _auth.currentUser.value;

  String get name => user?.name ?? '';
  String get email => user?.email ?? '';
  bool get verified => user?.isVerified ?? false;

  /// First letter of the user's name, shown when there is no avatar image.
  String get initial => user?.initial ?? '?';

  /// The API does not expose an avatar image yet; views fall back to
  /// an initial-based avatar when this is empty.
  String get avatarUrl => '';

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

  final isLoggingOut = false.obs;

  Future<void> logout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    try {
      await _auth.logout();
    } finally {
      isLoggingOut.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
