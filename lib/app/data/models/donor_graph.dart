/// Data behind the "Jaringan Donatur" visualization
/// (`GET /api/campaigns/:id/donor-graph`).
///
/// All on-chain data is pre-indexed by the backend; [explorerUrl] is a plain
/// destination URL that is only ever opened in an external browser — never
/// fetched or parsed by the app.
class DonorGraph {
  final String campaignId;
  final String campaignName;

  /// Total number of donors, which can exceed [donations].length when the
  /// backend truncates the list. The difference is shown as one
  /// "+N donatur lain" node.
  final int donorCount;

  final String totalRaisedFormatted;
  final List<DonorGraphDonation> donations;

  const DonorGraph({
    required this.campaignId,
    required this.campaignName,
    required this.donorCount,
    required this.totalRaisedFormatted,
    required this.donations,
  });

  factory DonorGraph.fromJson(Map<String, dynamic> json) {
    return DonorGraph(
      campaignId: (json['campaignId'] as String?) ?? '',
      campaignName: (json['campaignName'] as String?) ?? 'Kampanye',
      donorCount: json['donorCount'] is num
          ? (json['donorCount'] as num).toInt()
          : 0,
      totalRaisedFormatted: (json['totalRaisedFormatted'] as String?) ?? 'Rp0',
      donations: (json['donations'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(DonorGraphDonation.fromJson)
          .toList(),
    );
  }

  /// Donors beyond the ones listed in [donations]; 0 when everything fits.
  int get remainingDonorCount {
    final remaining = donorCount - donations.length;
    return remaining > 0 ? remaining : 0;
  }

  /// The signed-in user's own donation, when present in the list.
  DonorGraphDonation? get currentUserDonation {
    for (final donation in donations) {
      if (donation.isCurrentUser) return donation;
    }
    return null;
  }
}

class DonorGraphDonation {
  final String id;
  final String donorName;
  final String amountFormatted;
  final String status;
  final bool isCurrentUser;

  /// Block-explorer URL for this donation's transaction. Pure destination
  /// string — opened externally on demand, never fetched by the app.
  final String explorerUrl;

  const DonorGraphDonation({
    required this.id,
    required this.donorName,
    required this.amountFormatted,
    required this.status,
    required this.isCurrentUser,
    required this.explorerUrl,
  });

  factory DonorGraphDonation.fromJson(Map<String, dynamic> json) {
    return DonorGraphDonation(
      id: (json['id'] as String?) ?? '',
      donorName: (json['donorName'] as String?) ?? 'Hamba Allah',
      amountFormatted: (json['amountFormatted'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      isCurrentUser: json['isCurrentUser'] == true,
      explorerUrl: (json['explorerUrl'] as String?) ?? '',
    );
  }

  /// "0x685540c5…30faeb4" — shortened tx hash pulled from [explorerUrl].
  String get shortTxHash {
    final match = RegExp(r'0x[0-9a-fA-F]+').firstMatch(explorerUrl);
    if (match == null) return '';
    final hash = match.group(0)!;
    if (hash.length <= 18) return hash;
    return '${hash.substring(0, 10)}…${hash.substring(hash.length - 6)}';
  }
}
