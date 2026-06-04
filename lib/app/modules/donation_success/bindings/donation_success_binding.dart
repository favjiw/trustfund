import 'package:get/get.dart';

import '../controllers/donation_success_controller.dart';

class DonationSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonationSuccessController>(() => DonationSuccessController());
  }
}
