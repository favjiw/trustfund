import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exceptions.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/campaign_detail.dart';
import '../../../data/models/donation_charge.dart';
import '../../../data/models/donation_nominal.dart';
import '../../../data/models/payment_method.dart';
import '../../../data/repositories/donation_repository.dart';
import '../../../routes/app_pages.dart';

class DonationController extends GetxController {
  final DonationRepository _repository = DonationRepository.instance;

  final TextEditingController customAmountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  /// Index of the selected preset nominal; -1 when a custom amount is typed.
  final RxInt selectedNominal = 1.obs;
  final RxnInt customAmount = RxnInt();
  final RxInt selectedPayment = 1.obs;
  final RxBool hideName = false.obs;

  /// True while the donation is being created (Snap token generation).
  final RxBool isSubmitting = false.obs;

  late final String campaignId;
  late final String campaignTitle;
  late final String campaignOrganizer;
  late final String campaignImageUrl;
  late final bool campaignVerified;

  final List<NominalOption> nominals = const [
    NominalOption(label: 'Dukung', value: '10k', amount: 10000),
    NominalOption(label: 'Populer', value: '25k', amount: 25000),
    NominalOption(label: 'Dukung', value: '50k', amount: 50000),
    NominalOption(label: 'Dukung', value: '100k', amount: 100000),
    NominalOption(label: 'Hero', value: '250k', amount: 250000),
    NominalOption(label: 'Impact', value: '500k', amount: 500000),
  ];

  final List<PaymentMethodOption> paymentMethods = const [
    PaymentMethodOption(label: 'GoPay', icon: Icons.account_balance_wallet_outlined),
    PaymentMethodOption(label: 'OVO', icon: Icons.payments_outlined),
    PaymentMethodOption(
      label: 'BCA Virtual Account',
      icon: Icons.credit_card_outlined,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    final detail = arg is CampaignDetail ? arg : null;
    campaignId = detail?.id ?? '';
    campaignTitle =
        detail?.title ?? 'Pembangunan Sekolah Terpencil di Maluku';
    campaignOrganizer = detail?.organizer ?? 'Yayasan Senyum Anak';
    campaignImageUrl = detail?.imageUrl ??
        'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80';
    campaignVerified = detail?.verified ?? true;
    customAmountController.addListener(_onCustomAmountChanged);
  }

  void _onCustomAmountChanged() {
    final raw = customAmountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) {
      customAmount.value = null;
    } else {
      customAmount.value = int.tryParse(raw);
      selectedNominal.value = -1;
    }
  }

  void onNominalSelected(int index) {
    selectedNominal.value = index;
    customAmount.value = null;
    if (customAmountController.text.isNotEmpty) {
      customAmountController.clear();
    }
  }

  void onPaymentSelected(int index) => selectedPayment.value = index;

  void toggleHideName(bool value) => hideName.value = value;

  int get totalAmount {
    if (customAmount.value != null && customAmount.value! > 0) {
      return customAmount.value!;
    }
    final index = selectedNominal.value;
    if (index >= 0 && index < nominals.length) {
      return nominals[index].amount;
    }
    return 0;
  }

  String get formattedTotal => 'Rp${_formatThousands(totalAmount)}';

  String _formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// The donor's display name for this donation, honouring the "anonymous"
  /// toggle and falling back to a generic name when not signed in.
  String get _donorName {
    if (hideName.value) return 'Hamba Allah';
    final name = Get.find<AuthService>().currentUser.value?.name;
    return (name != null && name.trim().isNotEmpty) ? name.trim() : 'Hamba Allah';
  }

  Future<void> submitDonation() async {
    if (isSubmitting.value) return;

    if (totalAmount <= 0) {
      Get.snackbar(
        'Nominal belum dipilih',
        'Pilih atau masukkan nominal donasi terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (campaignId.isEmpty) {
      Get.snackbar(
        'Kampanye tidak valid',
        'Tidak dapat memproses donasi untuk kampanye ini.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final charge = await _repository.startDonation(
        campaignId: campaignId,
        donorName: _donorName,
        amount: totalAmount,
      );

      Get.toNamed(
        Routes.DONATION_QRIS,
        arguments: DonationPaymentArgs(
          charge: charge,
          campaignId: campaignId,
          campaignTitle: campaignTitle,
          organizer: campaignOrganizer,
          imageUrl: campaignImageUrl,
          verified: campaignVerified,
          donorName: _donorName,
        ),
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'Gagal memproses donasi',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Gagal memproses donasi',
        'Terjadi kesalahan. Coba lagi nanti.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    customAmountController.removeListener(_onCustomAmountChanged);
    customAmountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
