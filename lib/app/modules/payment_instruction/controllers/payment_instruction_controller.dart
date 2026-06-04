import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/models/donation_receipt.dart';
import '../../../routes/app_pages.dart';

class PaymentInstructionController extends GetxController {
  late final DonationReceipt receipt;

  final Rx<Duration> remaining =
      const Duration(hours: 23, minutes: 45, seconds: 10).obs;
  final RxBool stepsExpanded = true.obs;

  Timer? _timer;

  final List<String> steps = const [
    'Buka aplikasi m-BCA dan masukkan kode akses Anda.',
    'Pilih menu m-Transfer > BCA Virtual Account.',
    'Masukkan nomor Virtual Account di atas, lalu konfirmasi nominal.',
    'Selesaikan transaksi dan simpan bukti pembayaran Anda.',
  ];

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    receipt = arg is DonationReceipt ? arg : _fallbackReceipt();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.value.inSeconds <= 0) {
        _timer?.cancel();
        return;
      }
      remaining.value = remaining.value - const Duration(seconds: 1);
    });
  }

  String get formattedCountdown {
    final d = remaining.value;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }

  void toggleSteps() => stepsExpanded.value = !stepsExpanded.value;

  void copyVaNumber() {
    Clipboard.setData(ClipboardData(text: receipt.vaNumber));
    Get.snackbar(
      'Disalin',
      'Nomor Virtual Account telah disalin.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void confirmPayment() =>
      Get.offNamed(Routes.DONATION_SUCCESS, arguments: receipt);

  void cancelDonation() => Get.back();

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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
