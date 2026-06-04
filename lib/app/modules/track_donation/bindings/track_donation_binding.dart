import 'package:get/get.dart';

import '../controllers/track_donation_controller.dart';

class TrackDonationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackDonationController>(() => TrackDonationController());
  }
}
