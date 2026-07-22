import 'package:get/get.dart';

import '../controllers/donation_qris_controller.dart';

class DonationQrisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonationQrisController>(() => DonationQrisController());
  }
}
