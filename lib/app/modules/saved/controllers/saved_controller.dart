import 'package:get/get.dart';

import '../../../data/models/saved_campaign.dart';
import '../../../routes/app_pages.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';

class SavedController extends GetxController {
  static const int _campaignTabIndex = 1;

  final String subtitle = 'Kampanye yang Anda simpan untuk dipantau';

  final RxInt selectedFilter = 0.obs;

  final List<String> filters = const ['Semua', 'Aktif', 'Selesai'];

  final RxList<SavedCampaign> savedCampaigns = <SavedCampaign>[
    const SavedCampaign(
      imageUrl:
          'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
      title: 'Bantu Renovasi Sekolah Dasar di Pelosok NTT',
      organizer: 'Yayasan Senyum Anak',
      verified: true,
      trustScore: 98,
      raisedLabel: 'Rp150.000.000',
      targetLabel: 'terkumpul dari Rp200.000.000',
      progress: 0.75,
      daysLeftLabel: '2 hari lagi',
      status: SavedStatus.active,
    ),
    const SavedCampaign(
      imageUrl:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=800&q=80',
      title: 'Peralatan Medis untuk Klinik Desa Sejahtera',
      organizer: 'Medis Nusantara',
      verified: true,
      trustScore: 95,
      raisedLabel: 'Rp45.000.000',
      targetLabel: 'terkumpul dari Rp100.000.000',
      progress: 0.45,
      daysLeftLabel: '14 hari lagi',
      status: SavedStatus.active,
    ),
    const SavedCampaign(
      imageUrl:
          'https://images.unsplash.com/photo-1594398901394-4e34939a4fd0?auto=format&fit=crop&w=800&q=80',
      title: 'Sumur Bersih Untuk Sumba',
      organizer: 'Air untuk Kehidupan',
      verified: false,
      trustScore: 99,
      raisedLabel: 'Rp80.000.000',
      targetLabel: 'terkumpul dari Rp80.000.000',
      progress: 1.0,
      daysLeftLabel: '',
      status: SavedStatus.completed,
    ),
  ].obs;

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

  void goToCampaigns() {
    if (Get.isRegistered<BotNavBarController>()) {
      Get.find<BotNavBarController>().changePage(_campaignTabIndex);
    } else {
      Get.toNamed(Routes.CAMPAIGN);
    }
  }
}
