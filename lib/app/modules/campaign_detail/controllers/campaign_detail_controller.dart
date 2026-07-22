import 'package:get/get.dart';

import '../../../core/utils/url_launcher_helper.dart';
import '../../../data/models/campaign_detail.dart';
import '../../../data/models/campaign_item.dart';
import '../../../data/models/donor_graph.dart';
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

  // ── Donor graph (Donatur tab) ─────────────────────────────────────────

  static const int _donaturTabIndex = 3;

  final RxBool isGraphLoading = false.obs;
  final RxBool graphError = false.obs;
  final Rxn<DonorGraph> donorGraph = Rxn<DonorGraph>();

  void onTabSelected(int index) {
    selectedTab.value = index;
    // Fetched lazily so opening the detail page stays one request.
    if (index == _donaturTabIndex &&
        donorGraph.value == null &&
        !isGraphLoading.value) {
      loadDonorGraph();
    }
  }

  Future<void> loadDonorGraph() async {
    isGraphLoading.value = true;
    graphError.value = false;
    try {
      donorGraph.value = await _repository.fetchDonorGraph(_resolveId());
    } catch (_) {
      graphError.value = true;
    } finally {
      isGraphLoading.value = false;
    }
  }

  /// Opens the campaign's on-chain creation transaction in the block explorer.
  void openExplorer() => openExternalUrl(detail.value?.explorerUrl);

  void goToDonation() {
    final current = detail.value;
    if (current == null) return;
    Get.toNamed(Routes.DONATION, arguments: current);
  }
}
