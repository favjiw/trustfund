import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/campaign.dart';
import '../../../data/models/campaign_record.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  String get userName => Get.find<AuthService>().currentUser.value?.name ?? '';

  final CampaignRepository _repository = CampaignRepository.instance;

  final RxInt selectedCategory = 0.obs;

  final RxString searchQuery = ''.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxList<UrgentCampaign> urgentCampaigns = <UrgentCampaign>[].obs;
  final RxList<PopularCampaign> popularCampaigns = <PopularCampaign>[].obs;

  final List<String> categories = Campaign.filterCategories;

  /// Urgent campaigns after applying the active search query and category chip.
  List<UrgentCampaign> get filteredUrgentCampaigns => urgentCampaigns
      .where((c) => _matches(c.category, c.title, c.organizer))
      .toList();

  /// Popular campaigns after applying the active search query and category chip.
  List<PopularCampaign> get filteredPopularCampaigns => popularCampaigns
      .where((c) => _matches(c.category, c.title, c.organizer))
      .toList();

  bool _matches(String category, String title, String organizer) {
    final query = searchQuery.value.trim().toLowerCase();
    final index = selectedCategory.value;
    final selected = index >= 0 && index < categories.length
        ? categories[index]
        : categories.first;
    final matchesCategory = index == 0 || category == selected;
    final matchesQuery = query.isEmpty ||
        title.toLowerCase().contains(query) ||
        organizer.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  Future<void> loadFeed() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      // Fetched in parallel so both projections share one in-flight API call
      // (sequential awaits would download the heavy list twice).
      final results = await Future.wait([
        _repository.fetchUrgent(),
        _repository.fetchPopular(),
      ]);
      urgentCampaigns.assignAll(results[0] as List<UrgentCampaign>);
      popularCampaigns.assignAll(results[1] as List<PopularCampaign>);
    } catch (_) {
      hasError.value = true;
      urgentCampaigns.clear();
      popularCampaigns.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onCategorySelected(int index) => selectedCategory.value = index;

  void onSearchChanged(String value) => searchQuery.value = value;

  void openCampaign(String id) =>
      Get.toNamed(Routes.CAMPAIGN_DETAIL, arguments: id);
}
