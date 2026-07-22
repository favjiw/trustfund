/// Immutable record of a submitted donation, passed through the payment ->
/// success -> tracking flow.
class DonationReceipt {
  final String campaignId;
  final String campaignTitle;
  final String organizer;
  final String imageUrl;
  final bool verified;
  final int amount;
  final String formattedAmount;
  final String paymentLabel;
  final String vaNumber;
  final String dateLabel;
  final String transactionHash;

  /// Midtrans order id, used to fetch on-chain proof via
  /// `GET /api/donations/{orderId}/status`. Empty for legacy/demo receipts.
  final String orderId;

  const DonationReceipt({
    required this.campaignId,
    required this.campaignTitle,
    required this.organizer,
    required this.imageUrl,
    required this.verified,
    required this.amount,
    required this.formattedAmount,
    required this.paymentLabel,
    required this.vaNumber,
    required this.dateLabel,
    required this.transactionHash,
    this.orderId = '',
  });
}
