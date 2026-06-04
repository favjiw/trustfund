/// Disbursement state of a tranche of campaign funds on the tracking page.
enum DisbursementStatus { disbursed, reviewing, waiting }

/// A single fund-disbursement step shown in the donation tracking timeline.
class DisbursementStep {
  final String title;
  final String amount;
  final DisbursementStatus status;
  final String? detail;
  final bool hasProof;

  const DisbursementStep({
    required this.title,
    required this.amount,
    required this.status,
    this.detail,
    this.hasProof = false,
  });

  String get statusLabel {
    switch (status) {
      case DisbursementStatus.disbursed:
        return 'Dana Cair';
      case DisbursementStatus.reviewing:
        return 'Sedang Direview';
      case DisbursementStatus.waiting:
        return 'Menunggu';
    }
  }
}
