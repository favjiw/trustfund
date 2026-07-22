import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/url_launcher_helper.dart';
import '../../../data/models/donation_charge.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../data/models/donor_graph.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../data/repositories/donation_repository.dart';
import '../../../routes/app_pages.dart';

class DonationSuccessController extends GetxController {
  final DonationRepository _repository = DonationRepository.instance;

  late final DonationReceipt receipt;

  /// On-chain proof fetched from the backend, when available.
  final Rxn<DonationOnChainStatus> onChain = Rxn<DonationOnChainStatus>();
  final RxBool isLoadingProof = false.obs;

  /// True once polling gave up without an on-chain proof (deposit not yet
  /// confirmed on chain). The card then offers a manual retry.
  final RxBool proofUnavailable = false.obs;

  /// Poll the status endpoint until the deposit is confirmed on chain
  /// (`DEPOSITED` with a txHash) or this many attempts elapse.
  static const Duration _pollInterval = Duration(seconds: 4);
  static const int _maxAttempts = 15; // ~1 minute

  Timer? _proofTimer;
  int _attempts = 0;

  /// Transaction hash to display: the fetched on-chain hash when present,
  /// otherwise the receipt's (legacy/demo) value.
  String get displayHash {
    final hash = onChain.value?.txHash;
    if (hash != null && hash.isNotEmpty) return hash;
    return receipt.transactionHash;
  }

  bool get hasProof => onChain.value?.hasProof ?? false;

  // ── Donor network ("Jaringan Donatur") ────────────────────────────────

  final Rxn<DonorGraph> donorGraph = Rxn<DonorGraph>();
  final RxBool isGraphLoading = false.obs;
  final RxBool graphError = false.obs;

  Future<void> loadDonorGraph() async {
    if (receipt.campaignId.isEmpty) return;
    isGraphLoading.value = true;
    graphError.value = false;
    try {
      donorGraph.value =
          await CampaignRepository.instance.fetchDonorGraph(receipt.campaignId);
    } catch (_) {
      // Keep any previously loaded graph; only flag an error when the
      // section would otherwise be blank.
      if (donorGraph.value == null) graphError.value = true;
    } finally {
      isGraphLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    receipt = arg is DonationReceipt ? arg : _fallbackReceipt();
    if (receipt.orderId.isNotEmpty) {
      _startProofPolling();
    }
    loadDonorGraph();
  }

  void _startProofPolling() {
    _proofTimer?.cancel();
    _attempts = 0;
    proofUnavailable.value = false;
    _checkProofOnce();
    _proofTimer = Timer.periodic(_pollInterval, (_) => _checkProofOnce());
  }

  Future<void> _checkProofOnce() async {
    if (isLoadingProof.value) return;
    isLoadingProof.value = true;
    _attempts++;
    try {
      onChain.value = await _repository.fetchOnChainStatus(receipt.orderId);
    } catch (_) {
      // Best-effort; the next tick retries.
    } finally {
      isLoadingProof.value = false;
    }

    if (hasProof) {
      _stopProofPolling();
      // Refresh so the user's freshly deposited donation shows in the graph.
      loadDonorGraph();
    } else if (_attempts >= _maxAttempts) {
      _stopProofPolling();
      proofUnavailable.value = true;
    }
  }

  void _stopProofPolling() {
    _proofTimer?.cancel();
    _proofTimer = null;
  }

  /// Manual re-check for the on-chain proof (after the backend confirms the
  /// deposit on chain).
  void refreshProof() {
    if (receipt.orderId.isEmpty) return;
    _startProofPolling();
  }

  void copyTransactionHash() {
    final hash = displayHash;
    if (hash.isEmpty) return;
    Clipboard.setData(ClipboardData(text: hash));
    Get.snackbar(
      'Disalin',
      'Transaction hash telah disalin.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openExplorer() => openExternalUrl(onChain.value?.explorerUrl);

  void trackDonation() =>
      Get.toNamed(Routes.TRACK_DONATION, arguments: receipt);

  void backToHome() => Get.offAllNamed(Routes.BOTNAVBAR);

  @override
  void onClose() {
    _stopProofPolling();
    super.onClose();
  }

  DonationReceipt _fallbackReceipt() => const DonationReceipt(
        campaignId: 'cmrkpwxez0001fci7ni7koeie',
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
