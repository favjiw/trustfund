import 'package:get/get.dart';

import '../../../data/models/disbursement_step.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../routes/app_pages.dart';

class TrackDonationController extends GetxController {
  late final DonationReceipt receipt;

  final String disbursedPercentLabel = '45%';
  final double disbursedProgress = 0.45;

  final List<DisbursementStep> steps = const [
    DisbursementStep(
      title: 'Penggalangan Dana Awal',
      amount: 'Rp45.000.000',
      status: DisbursementStatus.disbursed,
      detail: 'Divalidasi AI (skor 94%) · tercatat on-chain',
      hasProof: true,
    ),
    DisbursementStep(
      title: 'Pembelian Material',
      amount: 'Rp60.000.000',
      status: DisbursementStatus.reviewing,
      detail: 'Menunggu validasi AI / review Pemda terkait kuitansi pembelian '
          'material bangunan.',
    ),
    DisbursementStep(
      title: 'Renovasi Fisik & Serah Terima',
      amount: 'Rp95.000.000',
      status: DisbursementStatus.waiting,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    receipt = arg is DonationReceipt ? arg : _fallbackReceipt();
  }

  void viewProof(int index) {
    // Slice-only: proof deep-link is out of scope for this pass.
  }

  void backToHome() => Get.offAllNamed(Routes.BOTNAVBAR);

  DonationReceipt _fallbackReceipt() => const DonationReceipt(
        campaignTitle: 'Bantu Renovasi Sekolah Dasar di Pelosok NTT',
        organizer: 'Yayasan Senyum Anak',
        imageUrl:
            'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
        verified: true,
        amount: 50000,
        formattedAmount: 'Rp50.000',
        paymentLabel: 'BCA Virtual Account',
        vaNumber: '8808 0812 3456 7890',
        dateLabel: '02 Jun 2026, 14:32',
        transactionHash: '0x7a3f...9b21',
      );
}
