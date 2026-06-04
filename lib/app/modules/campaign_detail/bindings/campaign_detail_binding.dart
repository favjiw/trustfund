import 'package:get/get.dart';

import '../controllers/campaign_detail_controller.dart';

class CampaignDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignDetailController>(() => CampaignDetailController());
  }
}
