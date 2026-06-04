import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/campaign.dart';

class HomeController extends GetxController {
  final String userName = 'Gilang';

  final TextEditingController searchController = TextEditingController();

  final RxInt selectedCategory = 0.obs;
  final RxInt navIndex = 0.obs;

  final List<String> categories = const [
    'Semua',
    'Infrastruktur',
    'Pendidikan',
  ];

  final List<UrgentCampaign> urgentCampaigns = const [
    UrgentCampaign(
      imageUrl:
          'https://imgs.mongabay.com/wp-content/uploads/sites/20/2021/08/04092006/1-Indonesian-village-rising-tidal-floodwaters-768x512.jpg',
      title: 'Banjir Sumatera',
      organizer: 'Rumah Bantu',
      verified: true,
      raisedLabel: 'Rp70.000.000 dari Rp100.000.000',
      daysLeftLabel: '2 hari lagi',
      progress: 0.7,
    ),
    UrgentCampaign(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/6/6b/I35_Bridge_Collapse_4crop.jpg',
      title: 'Jembatan Ambruk',
      organizer: 'KYC',
      verified: true,
      raisedLabel: 'Rp10.000.000 dari Rp50.000.000',
      daysLeftLabel: '3 hari lagi',
      progress: 0.2,
    ),
  ];

  final List<PopularCampaign> popularCampaigns = const [
    PopularCampaign(
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0326/7189/files/Mangrove_seedlings_Sunderbans_Reforestation.jpg?v=1722463362',
      title: 'Program Penanaman 10.000 Pohon Mangrove',
      organizer: 'Rand Ent',
      verified: true,
      donaturLabel: '1.200 Donatur',
      amountLabel: 'Rp 842.000.000',
    ),
    PopularCampaign(
      imageUrl:
          'https://worldconcern.org/migration/images/assets/post/ch16amkereribecd026-scr.jpg',
      title: 'Air Bersih untuk Desa Dove',
      organizer: 'Bantu bantu',
      verified: true,
      donaturLabel: '600 Donatur',
      amountLabel: 'Rp 523.000.000',
    ),
  ];

  void onCategorySelected(int index) => selectedCategory.value = index;

  void onNavTapped(int index) => navIndex.value = index;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
