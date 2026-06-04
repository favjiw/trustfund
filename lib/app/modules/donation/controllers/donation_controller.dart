import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/campaign_detail.dart';
import '../../../data/models/donation_nominal.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../data/models/payment_method.dart';
import '../../../routes/app_pages.dart';

class DonationController extends GetxController {
  final TextEditingController customAmountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  /// Index of the selected preset nominal; -1 when a custom amount is typed.
  final RxInt selectedNominal = 1.obs;
  final RxnInt customAmount = RxnInt();
  final RxInt selectedPayment = 1.obs;
  final RxBool hideName = false.obs;

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

  void submitDonation() {
    if (totalAmount <= 0) {
      Get.snackbar(
        'Nominal belum dipilih',
        'Pilih atau masukkan nominal donasi terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final paymentIndex = selectedPayment.value;
    final paymentLabel =
    (paymentIndex >= 0 && paymentIndex < paymentMethods.length)
        ? paymentMethods[paymentIndex].label
        : paymentMethods.first.label;

    final receipt = DonationReceipt(
      campaignTitle: campaignTitle,
      organizer: campaignOrganizer,
      imageUrl: campaignImageUrl,
      verified: campaignVerified,
      amount: totalAmount,
      formattedAmount: formattedTotal,
      paymentLabel: paymentLabel,
      vaNumber: '8808 0812 3456 7890',
      dateLabel: _formatDate(DateTime.now()),
      transactionHash: '0x7a3f...9b21',
    );

    Get.toNamed(Routes.PAYMENT_INSTRUCTION, arguments: receipt);
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
    customAmountController.removeListener(_onCustomAmountChanged);
    customAmountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
