import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final String name = 'Gilang Ramadhan';
  final String email = 'gilang@email.com';
  final String avatarUrl =
      'https://randomuser.me/api/portraits/men/75.jpg';
  final bool verified = true;

  final String totalDonationLabel = 'Rp12.45M';
  final String supportedCount = '14';
  final String livesHelped = '450+';

  final String appVersion = 'TrustFund v1.0.0';

  void logout() => Get.offAllNamed(Routes.LOGIN);
}
