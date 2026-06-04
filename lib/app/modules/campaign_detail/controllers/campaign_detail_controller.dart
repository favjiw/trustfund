import 'package:get/get.dart';

import '../../../data/models/campaign_detail.dart';
import '../../../data/models/campaign_item.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../routes/app_pages.dart';

class CampaignDetailController extends GetxController {
  final CampaignRepository _repository = CampaignRepository.instance;

  final RxInt selectedTab = 0.obs;

  final List<String> tabs = const ['Detail', 'RAB', 'Milestone', 'Donatur'];

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final Rxn<CampaignDetail> detail = Rxn<CampaignDetail>();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      detail.value = await _repository.fetchDetailById(_resolveId());
    } catch (_) {
      hasError.value = true;
      detail.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Accepts either a campaign id (new flow) or a [CampaignItem] (legacy
  /// argument) and falls back to the first record when nothing is passed.
  String _resolveId() {
    final arg = Get.arguments;
    if (arg is String) return arg;
    if (arg is CampaignItem) return arg.id;
    return 'c1';
  }

  void onTabSelected(int index) => selectedTab.value = index;

  void goToDonation() {
    final current = detail.value;
    if (current == null) return;
    Get.toNamed(Routes.DONATION, arguments: current);
  }
}
