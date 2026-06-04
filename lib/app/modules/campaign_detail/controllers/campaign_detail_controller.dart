import 'package:get/get.dart';

import '../../../data/models/campaign_detail.dart';
import '../../../data/models/campaign_item.dart';
import '../../../data/models/milestone_item.dart';
import '../../../data/models/rab_item.dart';
import '../../../routes/app_pages.dart';

class CampaignDetailController extends GetxController {
  final RxInt selectedTab = 0.obs;

  final List<String> tabs = const ['Detail', 'RAB', 'Milestone', 'Donatur'];

  late final CampaignDetail detail;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    final item = arg is CampaignItem ? arg : null;
    detail = CampaignDetail(
      imageUrl: item?.imageUrl ??
          'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
      category: item?.category ?? 'Pendidikan',
      location: 'NTT, Indonesia',
      title: item?.title ?? 'Bantu Renovasi Sekolah Dasar di Pelosok NTT',
      organizer: item?.organizer ?? 'Yayasan Senyum Anak',
      organizerInitial: item?.organizerInitial ?? 'Y',
      verified: item?.verified ?? true,
      trustScore: item?.trustScore ?? 98,
      raisedLabel: item?.raisedLabel ?? 'Rp150.000.000',
      targetLabel: item?.targetLabel ?? 'terkumpul dari target Rp200.000.000',
      progress: item?.progress ?? 0.75,
      percentLabel: item?.percentLabel ?? '75%',
      donaturValue: '1.240',
      daysLeftValue: '2 hari',
      description: const [
        'SDN Inpres di Kabupaten Kupang saat ini berada dalam kondisi yang '
            'memprihatinkan. Sejak diterjang badai dua tahun lalu, atap di tiga '
            'ruang kelas utama masih bocor dan membahayakan para siswa saat '
            'musim hujan tiba.',
        'Program renovasi ini mencakup penggantian total atap baja ringan, '
            'perbaikan plafon, pengecatan dinding, serta pengadaan meja dan '
            'kursi baru untuk 120 siswa. Kami mengundang Bapak/Ibu untuk '
            'berpartisipasi dalam menciptakan ruang belajar yang layak bagi '
            'anak-anak di pelosok negeri.',
      ],
      rabItems: const [
        RabItem(name: 'Atap Baja Ringan (3 Kelas)', estimate: 'Rp85.000.000'),
        RabItem(name: 'Plafon & Interior', estimate: 'Rp45.000.000'),
        RabItem(name: 'Mebel (Meja/Kursi)', estimate: 'Rp40.000.000'),
        RabItem(name: 'Biaya Logistik & Pekerja', estimate: 'Rp30.000.000'),
      ],
      milestones: const [
        MilestoneItem(
          title: 'Penggalangan Dana Awal',
          subtitle: 'Validated on 12 Oct 2023',
          status: MilestoneStatus.done,
        ),
        MilestoneItem(
          title: 'Pembelian Material',
          subtitle: 'Target start: 1 Nov 2023',
          status: MilestoneStatus.inProgress,
        ),
        MilestoneItem(
          title: 'Renovasi Fisik & Serah Terima',
          subtitle: 'Estimasi Jan 2024',
          status: MilestoneStatus.upcoming,
        ),
      ],
    );
  }

  void onTabSelected(int index) => selectedTab.value = index;

  void goToDonation() => Get.toNamed(Routes.DONATION, arguments: detail);
}
