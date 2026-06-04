import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/campaign_item.dart';

class CampaignController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final RxInt selectedCategory = 0.obs;

  final String resultCountLabel = 'Menampilkan 24 kampanye';
  final String sortLabel = 'Terbaru';

  final List<String> categories = const [
    'Semua',
    'Pendidikan',
    'Infrastruktur',
  ];

  final List<CampaignItem> campaigns = const [
    CampaignItem(
      imageUrl:
          'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
      category: 'Pendidikan',
      title: 'Bantu Renovasi Sekolah Dasar di Pelosok NTT',
      organizer: 'Yayasan Senyum Anak',
      organizerInitial: 'Y',
      verified: true,
      trustScore: 98,
      raisedLabel: 'Rp150.000.000',
      targetLabel: 'dari target Rp200.000.000',
      progress: 0.75,
      percentLabel: '75%',
      donaturLabel: '1.240 Donatur',
      daysLeftLabel: '2 hari lagi',
    ),
    CampaignItem(
      imageUrl:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=800&q=80',
      category: 'Kesehatan',
      title: 'Peralatan Medis untuk Klinik Desa Sejahtera',
      organizer: 'Medis Nusantara',
      organizerInitial: 'M',
      verified: true,
      trustScore: 95,
      raisedLabel: 'Rp45.000.000',
      targetLabel: 'dari target Rp100.000.000',
      progress: 0.45,
      percentLabel: '45%',
      donaturLabel: '432 Donatur',
      daysLeftLabel: '14 hari lagi',
    ),
  ];

  void onCategorySelected(int index) => selectedCategory.value = index;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
