import 'package:get/get.dart';

import '../../../data/models/saved_campaign.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../routes/app_pages.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';

class SavedController extends GetxController {
  static const int _campaignTabIndex = 1;

  final CampaignRepository _repository = CampaignRepository.instance;

  final String subtitle = 'Kampanye yang Anda simpan untuk dipantau';

  final RxInt selectedFilter = 0.obs;

  final List<String> filters = const ['Semua', 'Aktif', 'Selesai'];

  final RxBool isLoading = true.obs;
  final RxList<SavedCampaign> savedCampaigns = <SavedCampaign>[].obs;

  Worker? _savedIdsWorker;

  @override
  void onInit() {
    super.onInit();
    loadSaved();
    // Keep this tab in sync with the shared saved store, so saving or unsaving
    // a campaign anywhere in the app updates the list live.
    _savedIdsWorker = ever(_repository.savedIds, (_) => _syncFromStore());
  }

  @override
  void onClose() {
    _savedIdsWorker?.dispose();
    super.onClose();
  }

  Future<void> loadSaved() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    _syncFromStore();
    isLoading.value = false;
  }

  void _syncFromStore() {
    savedCampaigns.assignAll(_repository.savedCampaignList());
  }

  List<SavedCampaign> get visibleCampaigns {
    switch (selectedFilter.value) {
      case 1:
        return savedCampaigns
            .where((c) => c.status == SavedStatus.active)
            .toList();
      case 2:
        return savedCampaigns
            .where((c) => c.status == SavedStatus.completed)
            .toList();
      default:
        return savedCampaigns.toList();
    }
  }

  void onFilterSelected(int index) => selectedFilter.value = index;

  void openDetail(String id) =>
      Get.toNamed(Routes.CAMPAIGN_DETAIL, arguments: id);

  void goToCampaigns() {
    if (Get.isRegistered<BotNavBarController>()) {
      Get.find<BotNavBarController>().changePage(_campaignTabIndex);
    } else {
      Get.toNamed(Routes.CAMPAIGN);
    }
  }
}
