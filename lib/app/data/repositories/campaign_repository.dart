import 'package:get/get.dart';

import '../models/campaign.dart';
import '../models/campaign_detail.dart';
import '../models/campaign_item.dart';
import '../models/campaign_record.dart';
import '../models/milestone_item.dart';
import '../models/rab_item.dart';
import '../models/saved_campaign.dart';

/// In-memory data source mimicking a backend. Every campaign-related view-model
/// is projected from [_all], so a tapped card always resolves to matching
/// detail content. The async methods add a small delay to drive loading states.
class CampaignRepository {
  CampaignRepository._();

  static final CampaignRepository instance = CampaignRepository._();

  static const Duration _listDelay = Duration(milliseconds: 700);
  static const Duration _detailDelay = Duration(milliseconds: 900);

  /// Reactive, in-memory set of saved campaign ids shared across the app.
  /// Seeded with a few demo saves; persists across navigation but not restart.
  final RxList<String> savedIds = <String>['c1', 'c2', 'c5'].obs;

  bool isSaved(String id) => savedIds.contains(id);

  void toggleSaved(String id) {
    if (savedIds.contains(id)) {
      savedIds.remove(id);
    } else {
      savedIds.add(id);
    }
  }

  /// Saved campaigns projected from the shared records, in saved order.
  List<SavedCampaign> savedCampaignList() {
    final byId = {for (final c in _all) c.id: c};
    return [
      for (final id in savedIds)
        if (byId[id] != null) byId[id]!.toSaved(),
    ];
  }

  Future<List<UrgentCampaign>> fetchUrgent() async {
    await Future.delayed(_listDelay);
    return _all.where((c) => c.isUrgent).map((c) => c.toUrgent()).toList();
  }

  Future<List<PopularCampaign>> fetchPopular() async {
    await Future.delayed(_listDelay);
    return _all.where((c) => c.isPopular).map((c) => c.toPopular()).toList();
  }

  Future<List<CampaignItem>> fetchCampaignItems() async {
    await Future.delayed(_listDelay);
    return _all.map((c) => c.toItem()).toList();
  }

  Future<CampaignDetail> fetchDetailById(String id) async {
    await Future.delayed(_detailDelay);
    final record = _all.firstWhere(
      (c) => c.id == id,
      orElse: () => _all.first,
    );
    return record.toDetail();
  }

  static const List<Campaign> _all = [
    Campaign(
      id: 'c1',
      imageUrl:
          'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
      category: 'Pendidikan',
      location: 'NTT, Indonesia',
      title: 'Bantu Renovasi Sekolah Dasar di Pelosok NTT',
      organizer: 'Yayasan Senyum Anak',
      organizerInitial: 'Y',
      verified: true,
      trustScore: 98,
      progress: 0.75,
      percentLabel: '75%',
      raisedLabel: 'Rp150.000.000',
      targetLabel: 'terkumpul dari target Rp200.000.000',
      raisedFullLabel: 'Rp150.000.000 dari Rp200.000.000',
      donaturValue: '1.240',
      donaturLabel: '1.240 Donatur',
      amountLabel: 'Rp 150.000.000',
      daysLeftValue: '2 hari',
      daysLeftLabel: '2 hari lagi',
      description: [
        'SDN Inpres di Kabupaten Kupang saat ini berada dalam kondisi yang '
            'memprihatinkan. Sejak diterjang badai dua tahun lalu, atap di tiga '
            'ruang kelas utama masih bocor dan membahayakan para siswa saat '
            'musim hujan tiba.',
        'Program renovasi ini mencakup penggantian total atap baja ringan, '
            'perbaikan plafon, pengecatan dinding, serta pengadaan meja dan '
            'kursi baru untuk 120 siswa. Kami mengundang Bapak/Ibu untuk '
            'berpartisipasi dalam menciptakan ruang belajar yang layak.',
      ],
      rabItems: [
        RabItem(name: 'Atap Baja Ringan (3 Kelas)', estimate: 'Rp85.000.000'),
        RabItem(name: 'Plafon & Interior', estimate: 'Rp45.000.000'),
        RabItem(name: 'Mebel (Meja/Kursi)', estimate: 'Rp40.000.000'),
        RabItem(name: 'Biaya Logistik & Pekerja', estimate: 'Rp30.000.000'),
      ],
      milestones: [
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
    ),
    Campaign(
      id: 'c2',
      imageUrl:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=800&q=80',
      category: 'Kesehatan',
      location: 'Jawa Tengah, Indonesia',
      title: 'Peralatan Medis untuk Klinik Desa Sejahtera',
      organizer: 'Medis Nusantara',
      organizerInitial: 'M',
      verified: true,
      trustScore: 95,
      progress: 0.45,
      percentLabel: '45%',
      raisedLabel: 'Rp45.000.000',
      targetLabel: 'terkumpul dari target Rp100.000.000',
      raisedFullLabel: 'Rp45.000.000 dari Rp100.000.000',
      donaturValue: '432',
      donaturLabel: '432 Donatur',
      amountLabel: 'Rp 45.000.000',
      daysLeftValue: '14 hari',
      daysLeftLabel: '14 hari lagi',
      description: [
        'Klinik Desa Sejahtera melayani lebih dari 3.000 warga, namun kini '
            'kekurangan peralatan medis dasar untuk pemeriksaan rutin ibu hamil '
            'dan lansia. Banyak pasien terpaksa dirujuk ke kota yang berjarak '
            'lebih dari tiga jam perjalanan.',
        'Donasi Anda akan digunakan untuk pengadaan alat USG portabel, tensimeter '
            'digital, serta tabung oksigen darurat. Setiap pembelian akan kami '
            'laporkan secara transparan kepada para donatur.',
      ],
      rabItems: [
        RabItem(name: 'USG Portabel', estimate: 'Rp55.000.000'),
        RabItem(name: 'Tensimeter & Alat Periksa', estimate: 'Rp20.000.000'),
        RabItem(name: 'Tabung Oksigen Darurat', estimate: 'Rp15.000.000'),
        RabItem(name: 'Distribusi & Pelatihan', estimate: 'Rp10.000.000'),
      ],
      milestones: [
        MilestoneItem(
          title: 'Verifikasi Kebutuhan Klinik',
          subtitle: 'Validated on 3 Sep 2023',
          status: MilestoneStatus.done,
        ),
        MilestoneItem(
          title: 'Pengadaan Alat Medis',
          subtitle: 'Target start: 20 Sep 2023',
          status: MilestoneStatus.inProgress,
        ),
        MilestoneItem(
          title: 'Pelatihan & Serah Terima',
          subtitle: 'Estimasi Des 2023',
          status: MilestoneStatus.upcoming,
        ),
      ],
    ),
    Campaign(
      id: 'c3',
      imageUrl:
          'https://imgs.mongabay.com/wp-content/uploads/sites/20/2021/08/04092006/1-Indonesian-village-rising-tidal-floodwaters-768x512.jpg',
      category: 'Infrastruktur',
      location: 'Sumatera, Indonesia',
      title: 'Banjir Sumatera',
      organizer: 'Rumah Bantu',
      organizerInitial: 'R',
      verified: true,
      trustScore: 92,
      progress: 0.7,
      percentLabel: '70%',
      raisedLabel: 'Rp70.000.000',
      targetLabel: 'terkumpul dari target Rp100.000.000',
      raisedFullLabel: 'Rp70.000.000 dari Rp100.000.000',
      donaturValue: '980',
      donaturLabel: '980 Donatur',
      amountLabel: 'Rp 70.000.000',
      daysLeftValue: '2 hari',
      daysLeftLabel: '2 hari lagi',
      description: [
        'Banjir bandang melanda beberapa desa di Sumatera dan menyebabkan ribuan '
            'warga kehilangan tempat tinggal. Kebutuhan mendesak saat ini adalah '
            'makanan, air bersih, dan tenda darurat bagi para pengungsi.',
        'Tim relawan Rumah Bantu sudah berada di lokasi dan siap menyalurkan '
            'bantuan secara langsung. Setiap donasi akan dicatat dan dilaporkan '
            'untuk memastikan bantuan tepat sasaran.',
      ],
      rabItems: [
        RabItem(name: 'Paket Sembako (500 KK)', estimate: 'Rp40.000.000'),
        RabItem(name: 'Air Bersih & Sanitasi', estimate: 'Rp30.000.000'),
        RabItem(name: 'Tenda & Selimut Darurat', estimate: 'Rp20.000.000'),
        RabItem(name: 'Logistik Relawan', estimate: 'Rp10.000.000'),
      ],
      milestones: [
        MilestoneItem(
          title: 'Asesmen Lokasi Bencana',
          subtitle: 'Validated on 28 May 2026',
          status: MilestoneStatus.done,
        ),
        MilestoneItem(
          title: 'Penyaluran Bantuan Tahap 1',
          subtitle: 'Sedang berjalan',
          status: MilestoneStatus.inProgress,
        ),
        MilestoneItem(
          title: 'Pemulihan & Pelaporan Akhir',
          subtitle: 'Estimasi Jul 2026',
          status: MilestoneStatus.upcoming,
        ),
      ],
      isUrgent: true,
    ),
    Campaign(
      id: 'c4',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/6/6b/I35_Bridge_Collapse_4crop.jpg',
      category: 'Infrastruktur',
      location: 'Kalimantan, Indonesia',
      title: 'Jembatan Ambruk',
      organizer: 'KYC',
      organizerInitial: 'K',
      verified: true,
      trustScore: 90,
      progress: 0.2,
      percentLabel: '20%',
      raisedLabel: 'Rp10.000.000',
      targetLabel: 'terkumpul dari target Rp50.000.000',
      raisedFullLabel: 'Rp10.000.000 dari Rp50.000.000',
      donaturValue: '210',
      donaturLabel: '210 Donatur',
      amountLabel: 'Rp 10.000.000',
      daysLeftValue: '3 hari',
      daysLeftLabel: '3 hari lagi',
      description: [
        'Jembatan penghubung utama antar desa ambruk akibat usia dan beban '
            'berlebih. Akibatnya, anak-anak harus memutar sejauh delapan '
            'kilometer untuk mencapai sekolah terdekat.',
        'Dana yang terkumpul akan digunakan untuk membangun jembatan gantung '
            'sementara yang aman, sembari menunggu pembangunan permanen oleh '
            'pemerintah daerah.',
      ],
      rabItems: [
        RabItem(name: 'Material Baja & Kabel', estimate: 'Rp25.000.000'),
        RabItem(name: 'Pondasi & Pengecoran', estimate: 'Rp15.000.000'),
        RabItem(name: 'Upah Tukang', estimate: 'Rp10.000.000'),
      ],
      milestones: [
        MilestoneItem(
          title: 'Survei Struktur Jembatan',
          subtitle: 'Validated on 30 May 2026',
          status: MilestoneStatus.done,
        ),
        MilestoneItem(
          title: 'Pembangunan Jembatan Sementara',
          subtitle: 'Target start: 8 Jun 2026',
          status: MilestoneStatus.inProgress,
        ),
        MilestoneItem(
          title: 'Uji Kelayakan & Pembukaan',
          subtitle: 'Estimasi Agu 2026',
          status: MilestoneStatus.upcoming,
        ),
      ],
      isUrgent: true,
    ),
    Campaign(
      id: 'c5',
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0326/7189/files/Mangrove_seedlings_Sunderbans_Reforestation.jpg?v=1722463362',
      category: 'Lingkungan',
      location: 'Pesisir Utara Jawa, Indonesia',
      title: 'Program Penanaman 10.000 Pohon Mangrove',
      organizer: 'Rand Ent',
      organizerInitial: 'R',
      verified: true,
      trustScore: 97,
      progress: 0.84,
      percentLabel: '84%',
      raisedLabel: 'Rp842.000.000',
      targetLabel: 'terkumpul dari target Rp1.000.000.000',
      raisedFullLabel: 'Rp842.000.000 dari Rp1.000.000.000',
      donaturValue: '1.200',
      donaturLabel: '1.200 Donatur',
      amountLabel: 'Rp 842.000.000',
      daysLeftValue: '30 hari',
      daysLeftLabel: '30 hari lagi',
      description: [
        'Abrasi pantai di pesisir utara Jawa kian mengkhawatirkan dan mengancam '
            'permukiman serta tambak warga. Penanaman mangrove terbukti efektif '
            'menahan laju abrasi sekaligus memulihkan ekosistem pesisir.',
        'Program ini menargetkan penanaman 10.000 bibit mangrove yang dirawat '
            'bersama kelompok nelayan setempat. Setiap pohon akan dipetakan dan '
            'dipantau pertumbuhannya secara berkala.',
      ],
      rabItems: [
        RabItem(name: 'Bibit Mangrove (10.000)', estimate: 'Rp400.000.000'),
        RabItem(name: 'Penanaman & Perawatan', estimate: 'Rp250.000.000'),
        RabItem(name: 'Pemberdayaan Nelayan', estimate: 'Rp200.000.000'),
        RabItem(name: 'Monitoring & Pelaporan', estimate: 'Rp150.000.000'),
      ],
      milestones: [
        MilestoneItem(
          title: 'Pemetaan Lokasi Tanam',
          subtitle: 'Validated on 10 Apr 2026',
          status: MilestoneStatus.done,
        ),
        MilestoneItem(
          title: 'Penanaman Bibit Tahap 1',
          subtitle: 'Sedang berjalan',
          status: MilestoneStatus.inProgress,
        ),
        MilestoneItem(
          title: 'Perawatan & Evaluasi Tahunan',
          subtitle: 'Estimasi 2027',
          status: MilestoneStatus.upcoming,
        ),
      ],
      isPopular: true,
    ),
    Campaign(
      id: 'c6',
      imageUrl:
          'https://worldconcern.org/migration/images/assets/post/ch16amkereribecd026-scr.jpg',
      category: 'Infrastruktur',
      location: 'NTT, Indonesia',
      title: 'Air Bersih untuk Desa Dove',
      organizer: 'Bantu bantu',
      organizerInitial: 'B',
      verified: true,
      trustScore: 94,
      progress: 0.52,
      percentLabel: '52%',
      raisedLabel: 'Rp523.000.000',
      targetLabel: 'terkumpul dari target Rp1.000.000.000',
      raisedFullLabel: 'Rp523.000.000 dari Rp1.000.000.000',
      donaturValue: '600',
      donaturLabel: '600 Donatur',
      amountLabel: 'Rp 523.000.000',
      daysLeftValue: '21 hari',
      daysLeftLabel: '21 hari lagi',
      description: [
        'Warga Desa Dove harus berjalan kaki lebih dari lima kilometer setiap '
            'hari hanya untuk mengambil air yang sering kali tidak layak '
            'konsumsi. Hal ini berdampak langsung pada kesehatan anak-anak.',
        'Proyek ini akan membangun sumur bor dalam, instalasi pompa tenaga '
            'surya, serta jaringan pipa menuju titik-titik penampungan umum di '
            'tengah desa.',
      ],
      rabItems: [
        RabItem(name: 'Pengeboran Sumur Dalam', estimate: 'Rp300.000.000'),
        RabItem(name: 'Pompa Tenaga Surya', estimate: 'Rp250.000.000'),
        RabItem(name: 'Jaringan Pipa & Tandon', estimate: 'Rp300.000.000'),
        RabItem(name: 'Pemeliharaan & Pelatihan', estimate: 'Rp150.000.000'),
      ],
      milestones: [
        MilestoneItem(
          title: 'Survei Sumber Air',
          subtitle: 'Validated on 2 May 2026',
          status: MilestoneStatus.done,
        ),
        MilestoneItem(
          title: 'Pengeboran & Instalasi',
          subtitle: 'Sedang berjalan',
          status: MilestoneStatus.inProgress,
        ),
        MilestoneItem(
          title: 'Distribusi & Serah Terima',
          subtitle: 'Estimasi Sep 2026',
          status: MilestoneStatus.upcoming,
        ),
      ],
      isPopular: true,
    ),
  ];
}
