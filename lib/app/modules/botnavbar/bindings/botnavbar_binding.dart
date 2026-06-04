import 'package:get/get.dart';

import '../../campaign/controllers/campaign_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../saved/controllers/saved_controller.dart';
import '../controllers/botnavbar_controller.dart';

/// Registers the shell controller and every tab controller so the tabs are
/// ready the moment the [IndexedStack] builds them.
class BotNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BotNavBarController>(() => BotNavBarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CampaignController>(() => CampaignController());
    Get.lazyPut<SavedController>(() => SavedController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
