import 'dart:async';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/network/api_exceptions.dart';
import '../../../data/models/donation_charge.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../data/repositories/donation_repository.dart';
import '../../../routes/app_pages.dart';

/// Lifecycle phase of the QRIS payment screen.
enum QrisPhase { waiting, paid, expired, failed, error }

class DonationQrisController extends GetxController {
  final DonationRepository _repository = DonationRepository.instance;

  /// How often the backend donation status is polled.
  static const Duration _pollInterval = Duration(seconds: 4);

  /// Safety cap so polling stops even if the status never becomes terminal
  /// (Midtrans QRIS typically expires after ~15 minutes).
  static const Duration _maxWait = Duration(minutes: 15);

  late final DonationPaymentArgs args;
  late final WebViewController webViewController;

  final Rx<QrisPhase> phase = QrisPhase.waiting.obs;
  final RxString errorMessage = ''.obs;

  /// True while a sandbox payment is being triggered via the backend.
  final RxBool isPaying = false.obs;

  Timer? _pollTimer;
  Timer? _expiryTimer;
  bool _isPolling = false;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as DonationPaymentArgs;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(args.charge.qrisUrl));

    _startPolling();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkStatus());
    _expiryTimer = Timer(_maxWait, () {
      if (phase.value == QrisPhase.waiting) {
        _stopPolling();
        phase.value = QrisPhase.expired;
      }
    });
    // Kick off an immediate first check.
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    if (_isPolling || phase.value != QrisPhase.waiting) return;
    _isPolling = true;
    try {
      final status = await _repository.fetchStatus(
        campaignId: args.campaignId,
        donationId: args.charge.donationId,
      );
      switch (status) {
        case DonationStatus.paid:
          _onPaid();
          break;
        case DonationStatus.expired:
          _stopPolling();
          phase.value = QrisPhase.expired;
          break;
        case DonationStatus.failed:
          _stopPolling();
          phase.value = QrisPhase.failed;
          break;
        case DonationStatus.pending:
        case DonationStatus.unknown:
          break;
      }
    } catch (_) {
      // Transient polling errors are ignored; the next tick retries.
    } finally {
      _isPolling = false;
    }
  }

  void _onPaid() {
    _stopPolling();
    phase.value = QrisPhase.paid;

    final receipt = DonationReceipt(
      campaignId: args.campaignId,
      campaignTitle: args.campaignTitle,
      organizer: args.organizer,
      imageUrl: args.imageUrl,
      verified: args.verified,
      amount: args.charge.amountRupiah,
      formattedAmount: 'Rp${_formatThousands(args.charge.amountRupiah)}',
      paymentLabel: 'QRIS',
      vaNumber: args.charge.orderId,
      dateLabel: _formatDate(DateTime.now()),
      transactionHash: '',
      orderId: args.charge.orderId,
    );

    Get.offNamed(Routes.DONATION_SUCCESS, arguments: receipt);
  }

  /// Completes the payment for the selected nominal via the backend's sandbox
  /// simulate helper, then lets polling flip the screen to "paid".
  ///
  /// In production this button would not exist — a donor pays by scanning the
  /// QRIS with their own e-wallet — so any failure here is surfaced plainly.
  Future<void> payNow() async {
    if (isPaying.value || phase.value != QrisPhase.waiting) return;
    isPaying.value = true;

    ApiException? error;
    try {
      await _repository.simulatePayment(
        campaignId: args.campaignId,
        donationId: args.charge.donationId,
      );
    } on ApiException catch (e) {
      error = e;
    } catch (_) {
      error = const ApiException('Terjadi kesalahan. Coba lagi nanti.');
    }

    // The simulate call can mark the donation paid even when it ultimately
    // returns an error (the backend flips the status before a later step),
    // so always verify the real status before reporting a failure. On "paid"
    // this navigates away.
    await _checkStatus();

    if (phase.value == QrisPhase.waiting) {
      if (error == null) {
        Get.snackbar(
          'Menunggu konfirmasi',
          'Pembayaran diproses, menunggu konfirmasi…',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Gagal memproses pembayaran',
          error.statusCode == 404
              ? 'Endpoint pembayaran simulasi belum tersedia di server.'
              : error.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
    }

    isPaying.value = false;
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _expiryTimer?.cancel();
  }

  String get formattedAmount => 'Rp${_formatThousands(args.charge.amountRupiah)}';

  String _formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)} ${months[date.month - 1]} ${date.year}, '
        '${two(date.hour)}:${two(date.minute)}';
  }

  @override
  void onClose() {
    _stopPolling();
    super.onClose();
  }
}
