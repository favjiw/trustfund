import 'package:get/get.dart';

import '../../../data/models/campaign_item.dart';
import '../../../data/models/campaign_record.dart';
import '../../../data/repositories/campaign_repository.dart';

/// Ordering options for the Kampanye list.
enum CampaignSort { newest, mostRaised, endingSoon }

class CampaignController extends GetxController {
  final CampaignRepository _repository = CampaignRepository.instance;

  final RxInt selectedCategory = 0.obs;

  final RxString searchQuery = ''.obs;

  final Rx<CampaignSort> sortOption = CampaignSort.newest.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxList<CampaignItem> campaigns = <CampaignItem>[].obs;

  final List<String> categories = Campaign.filterCategories;

  /// Human-readable label for a sort option (used by the control and sheet).
  static String labelForSort(CampaignSort option) {
    switch (option) {
      case CampaignSort.newest:
        return 'Terbaru';
      case CampaignSort.mostRaised:
        return 'Terbanyak';
      case CampaignSort.endingSoon:
        return 'Segera berakhir';
    }
  }

  String get sortLabel => labelForSort(sortOption.value);

  /// Campaigns after applying the active search query, category chip and sort.
  List<CampaignItem> get filteredCampaigns {
    final query = searchQuery.value.trim().toLowerCase();
    final index = selectedCategory.value;
    final category = index >= 0 && index < categories.length
        ? categories[index]
        : categories.first;
    final results = campaigns.where((campaign) {
      final matchesCategory = index == 0 || campaign.category == category;
      final matchesQuery = query.isEmpty ||
          campaign.title.toLowerCase().contains(query) ||
          campaign.organizer.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    switch (sortOption.value) {
      case CampaignSort.newest:
        break;
      case CampaignSort.mostRaised:
        results.sort((a, b) => _raisedAmount(b).compareTo(_raisedAmount(a)));
        break;
      case CampaignSort.endingSoon:
        results.sort((a, b) => _daysLeft(a).compareTo(_daysLeft(b)));
        break;
    }
    return results;
  }

  /// Parses "Rp150.000.000" into 150000000 for amount-based sorting.
  int _raisedAmount(CampaignItem item) =>
      int.tryParse(item.raisedLabel.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  /// Parses the leading number from "14 hari lagi" for deadline sorting.
  int _daysLeft(CampaignItem item) {
    final match = RegExp(r'\d+').firstMatch(item.daysLeftLabel);
    return match == null ? 1 << 30 : int.parse(match.group(0)!);
  }

  String get resultCountLabel {
    if (isLoading.value) return 'Memuat kampanye...';
    if (hasError.value) return 'Gagal memuat kampanye';
    return 'Menampilkan ${filteredCampaigns.length} kampanye';
  }

  @override
  void onInit() {
    super.onInit();
    loadCampaigns();
  }

  Future<void> loadCampaigns() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final items = await _repository.fetchCampaignItems();
      campaigns.assignAll(items);
    } catch (_) {
      hasError.value = true;
      campaigns.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onCategorySelected(int index) => selectedCategory.value = index;

  void onSearchChanged(String value) => searchQuery.value = value;

  void onSortSelected(CampaignSort option) => sortOption.value = option;
}
