import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/models/donation_receipt.dart';
import '../../../routes/app_pages.dart';

class DonationSuccessController extends GetxController {
  late final DonationReceipt receipt;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    receipt = arg is DonationReceipt ? arg : _fallbackReceipt();
  }

  void copyTransactionHash() {
    Clipboard.setData(ClipboardData(text: receipt.transactionHash));
    Get.snackbar(
      'Disalin',
      'Transaction hash telah disalin.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openExplorer() {
    // Slice-only: blockchain explorer deep-link is out of scope for this pass.
  }

  void trackDonation() =>
      Get.toNamed(Routes.TRACK_DONATION, arguments: receipt);

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
