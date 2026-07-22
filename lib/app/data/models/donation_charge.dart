/// Payment status of a donation, derived from the backend donation `status`
/// field (which the Midtrans webhook keeps up to date).
enum DonationStatus {
  /// Awaiting payment (QRIS not yet paid).
  pending,

  /// Paid and deposited on-chain — the donation is complete.
  paid,

  /// The payment window elapsed without payment.
  expired,

  /// Payment failed, was cancelled, denied or refunded.
  failed,

  /// Status could not be determined.
  unknown;

  static DonationStatus fromApi(String? raw) {
    switch (raw) {
      case 'PENDING':
        return DonationStatus.pending;
      case 'PAID':
      case 'DEPOSITED':
      case 'CONFIRMED':
      case 'SETTLED':
      case 'SETTLEMENT':
      case 'CAPTURE':
        return DonationStatus.paid;
      case 'EXPIRED':
        return DonationStatus.expired;
      case 'FAILED':
      case 'CANCELLED':
      case 'CANCEL':
      case 'DENY':
      case 'DENIED':
      case 'REFUND':
      case 'REFUNDED':
        return DonationStatus.failed;
      default:
        return DonationStatus.unknown;
    }
  }

  bool get isTerminal =>
      this == DonationStatus.paid ||
      this == DonationStatus.expired ||
      this == DonationStatus.failed;
}

/// Result of starting a donation (`POST /api/campaigns/{id}/donations`).
///
/// The backend creates a Midtrans Snap transaction and returns a hosted
/// payment page ([qrisUrl]) that renders the scannable QRIS.
class DonationCharge {
  final String donationId;
  final String orderId;
  final String qrisUrl;
  final int amountRupiah;

  const DonationCharge({
    required this.donationId,
    required this.orderId,
    required this.qrisUrl,
    required this.amountRupiah,
  });

  factory DonationCharge.fromJson(Map<String, dynamic> json) {
    return DonationCharge(
      donationId: json['donationId'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      qrisUrl: json['qrisUrl'] as String? ?? '',
      amountRupiah: (json['amountRupiah'] as num?)?.toInt() ?? 0,
    );
  }
}

/// On-chain proof for a donation (`GET /api/donations/{orderId}/status`).
///
/// [txHash] and [explorerUrl] are `null` until the deposit is confirmed on
/// chain (e.g. while the donation is only `PAID`, not yet `DEPOSITED`).
class DonationOnChainStatus {
  final String orderId;
  final DonationStatus status;
  final String? txHash;
  final String? explorerUrl;

  const DonationOnChainStatus({
    required this.orderId,
    required this.status,
    this.txHash,
    this.explorerUrl,
  });

  /// Whether the on-chain transaction is available to view.
  bool get hasProof =>
      (txHash != null && txHash!.isNotEmpty) &&
      (explorerUrl != null && explorerUrl!.isNotEmpty);

  factory DonationOnChainStatus.fromJson(Map<String, dynamic> json) {
    return DonationOnChainStatus(
      orderId: json['orderId'] as String? ?? '',
      status: DonationStatus.fromApi(json['status'] as String?),
      txHash: json['txHash'] as String?,
      explorerUrl: json['explorerUrl'] as String?,
    );
  }
}

/// Arguments passed to the QRIS payment page: the started [charge] plus the
/// campaign context needed to poll status and build the success receipt.
class DonationPaymentArgs {
  final DonationCharge charge;
  final String campaignId;
  final String campaignTitle;
  final String organizer;
  final String imageUrl;
  final bool verified;
  final String donorName;

  const DonationPaymentArgs({
    required this.charge,
    required this.campaignId,
    required this.campaignTitle,
    required this.organizer,
    required this.imageUrl,
    required this.verified,
    required this.donorName,
  });
}
