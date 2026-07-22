import 'campaign.dart';
import 'campaign_detail.dart';
import 'campaign_item.dart';
import 'milestone_item.dart';
import 'rab_item.dart';
import 'saved_campaign.dart';

/// Single source of truth for one campaign. Every list/detail view-model used
/// across the app is projected from this record so the same tapped item always
/// resolves to matching content (mimicking a backend record fetched by [id]).
class Campaign {
  final String id;
  final String imageUrl;
  final String category;
  final String location;
  final String title;
  final String organizer;
  final String organizerInitial;
  final bool verified;
  final int trustScore;
  final double progress;
  final String percentLabel;

  /// "Rp150.000.000" — amount raised so far.
  final String raisedLabel;

  /// "dari target Rp200.000.000" — target sub-label.
  final String targetLabel;

  /// "Rp70.000.000 dari Rp100.000.000" — combined label for the urgent card.
  final String raisedFullLabel;

  /// "1.240" — raw donor count for the detail stat box.
  final String donaturValue;

  /// "1.240 Donatur" — donor count label for list cards.
  final String donaturLabel;

  /// "Rp 842.000.000" — headline amount for the popular card.
  final String amountLabel;

  /// "2 hari" — raw remaining-time value for the detail stat box.
  final String daysLeftValue;

  /// "2 hari lagi" — remaining-time label for list cards.
  final String daysLeftLabel;

  final List<String> description;
  final List<RabItem> rabItems;
  final List<MilestoneItem> milestones;

  /// Whether this record appears in the home "Mendesak" carousel.
  final bool isUrgent;

  /// Whether this record appears in the home "Kampanye Populer" list.
  final bool isPopular;

  /// On-chain id (e.g. "CMP-..."), empty when not available.
  final String onChainId;

  /// Blockchain explorer URL for the campaign's creation transaction.
  final String explorerUrl;

  /// Raw API status ("ACTIVE", "COMPLETED", ...).
  final String status;

  /// Whether the funding target has been reached.
  final bool isTargetReached;

  /// Whether the API still accepts donations for this campaign.
  final bool canDonate;

  const Campaign({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.title,
    required this.organizer,
    required this.organizerInitial,
    required this.verified,
    required this.trustScore,
    required this.progress,
    required this.percentLabel,
    required this.raisedLabel,
    required this.targetLabel,
    required this.raisedFullLabel,
    required this.donaturValue,
    required this.donaturLabel,
    required this.amountLabel,
    required this.daysLeftValue,
    required this.daysLeftLabel,
    required this.description,
    required this.rabItems,
    required this.milestones,
    this.isUrgent = false,
    this.isPopular = false,
    this.onChainId = '',
    this.explorerUrl = '',
    this.status = '',
    this.isTargetReached = false,
    this.canDonate = true,
  });

  /// Whether the campaign is live and should be shown in donor-facing lists.
  bool get isActive => status == 'ACTIVE';

  /// Category chip labels used by every donor-facing filter bar. The entries
  /// after "Semua" must match the humanized form of the API category enum
  /// (PEMBANGUNAN, PENGADAAN_BARANG, ALAT_KESEHATAN, REKONSTRUKSI_BENCANA)
  /// produced by [_humanizeCategory].
  static const List<String> filterCategories = [
    'Semua',
    'Pembangunan',
    'Pengadaan Barang',
    'Alat Kesehatan',
    'Rekonstruksi Bencana',
  ];

  /// Sentinel [progress] value meaning "funding progress is unknown".
  ///
  /// The backend does not expose a reliable raised amount, so campaigns loaded
  /// from the API present target + donor count only; progress bars and the
  /// percentage label are hidden for a negative value.
  static const double unknownProgress = -1.0;

  /// Builds a record from one campaign object returned by the NexTrust API
  /// (`GET /api/campaigns` list item or `GET /api/campaigns/{id}` detail).
  ///
  /// Only fields the API reliably provides are surfaced. Funding progress is
  /// left [unknownProgress] because the raised amount is not available.
  factory Campaign.fromApi(Map<String, dynamic> json) {
    final organizer = (json['foundation'] is Map)
        ? (json['foundation']['name'] as String?) ?? 'Yayasan'
        : 'Yayasan';

    final target = _asNum(json['targetAmount']);
    final targetLabel = _formatRupiah(target);
    final donorCount = _donorCount(json);
    final status = (json['status'] as String?) ?? '';
    final description = (json['description'] as String?)?.trim() ?? '';

    return Campaign(
      id: (json['id'] as String?) ?? '',
      imageUrl: (json['imageUrl'] as String?) ?? '',
      category: _humanizeCategory(json['category'] as String?),
      location: 'Indonesia',
      title: (json['title'] as String?) ?? 'Kampanye',
      organizer: organizer,
      organizerInitial:
          organizer.isNotEmpty ? organizer[0].toUpperCase() : 'Y',
      verified: status == 'ACTIVE',
      trustScore: _trustScore(json['aiScore']),
      progress: unknownProgress,
      percentLabel: '',
      raisedLabel: targetLabel,
      targetLabel: 'Target penggalangan dana',
      raisedFullLabel: 'Target $targetLabel',
      donaturValue: donorCount.toString(),
      donaturLabel: '$donorCount Donatur',
      amountLabel: _formatRupiah(target, spaced: true),
      daysLeftValue: _statusLabel(status),
      daysLeftLabel: _statusLabel(status),
      description: description.isEmpty ? const [] : [description],
      rabItems: _parseRab(json['rabData']),
      milestones: _parseMilestones(json['milestones']),
      onChainId: (json['onChainId'] as String?) ?? '',
      explorerUrl: (json['explorerUrl'] as String?) ?? '',
      status: status,
      isTargetReached: json['isTargetReached'] == true,
      canDonate: json['canDonate'] is bool
          ? json['canDonate'] as bool
          : status == 'ACTIVE' && json['isTargetReached'] != true,
    );
  }

  // ── API mapping helpers ─────────────────────────────────────────────────

  static num _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  static int _donorCount(Map<String, dynamic> json) {
    if (json['donorCount'] is int) return json['donorCount'] as int;
    final count = json['_count'];
    if (count is Map && count['donations'] is int) {
      return count['donations'] as int;
    }
    if (json['donations'] is List) return (json['donations'] as List).length;
    return 0;
  }

  /// Maps the AI review score (roughly 0–10) onto a 0–100 trust score.
  static int _trustScore(dynamic aiScore) {
    final score = _asNum(aiScore);
    if (score <= 0) return 0;
    return (score * 10).round().clamp(0, 100);
  }

  /// "PENGADAAN_BARANG" → "Pengadaan Barang".
  static String _humanizeCategory(String? raw) {
    if (raw == null || raw.isEmpty) return 'Umum';
    return raw
        .split('_')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'ACTIVE':
        return 'Aktif';
      case 'COMPLETED':
        return 'Selesai';
      case 'PENDING':
        return 'Menunggu';
      case 'FROZEN':
        return 'Dibekukan';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return status.isEmpty ? '-' : status;
    }
  }

  /// Formats a number as Indonesian rupiah, e.g. 50000000 → "Rp50.000.000".
  static String _formatRupiah(num value, {bool spaced = false}) {
    final digits = value.round().abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return spaced ? 'Rp $buffer' : 'Rp$buffer';
  }

  static List<RabItem> _parseRab(dynamic rabData) {
    if (rabData is! List) return const [];
    return rabData.whereType<Map>().map((row) {
      final item = (row['item'] as String?) ?? 'Item';
      final qty = _asNum(row['qty']);
      final harga = _asNum(row['harga']);
      final total = qty > 0 ? qty * harga : harga;
      return RabItem(name: item, estimate: _formatRupiah(total));
    }).toList();
  }

  static List<MilestoneItem> _parseMilestones(dynamic milestones) {
    if (milestones is! List) return const [];
    final rows = milestones.whereType<Map>().toList()
      ..sort((a, b) => _asNum(a['index']).compareTo(_asNum(b['index'])));
    return rows.map((row) {
      final title = (row['title'] as String?) ?? 'Milestone';
      final amount = _formatRupiah(_asNum(row['amount']));
      return MilestoneItem(
        title: title,
        subtitle: amount,
        status: _milestoneStatus(row['status'] as String?),
      );
    }).toList();
  }

  static MilestoneStatus _milestoneStatus(String? status) {
    switch (status) {
      case 'RELEASED':
      case 'APPROVED':
      case 'COMPLETED':
        return MilestoneStatus.done;
      case 'SUBMITTED':
      case 'IN_PROGRESS':
        return MilestoneStatus.inProgress;
      default:
        return MilestoneStatus.upcoming;
    }
  }

  UrgentCampaign toUrgent() => UrgentCampaign(
        id: id,
        imageUrl: imageUrl,
        category: category,
        title: title,
        organizer: organizer,
        verified: verified,
        raisedLabel: raisedFullLabel,
        daysLeftLabel: daysLeftLabel,
        progress: progress,
      );

  PopularCampaign toPopular() => PopularCampaign(
        id: id,
        imageUrl: imageUrl,
        category: category,
        title: title,
        organizer: organizer,
        verified: verified,
        donaturLabel: donaturLabel,
        amountLabel: amountLabel,
      );

  CampaignItem toItem() => CampaignItem(
        id: id,
        imageUrl: imageUrl,
        category: category,
        title: title,
        organizer: organizer,
        organizerInitial: organizerInitial,
        verified: verified,
        trustScore: trustScore,
        raisedLabel: raisedLabel,
        targetLabel: targetLabel,
        progress: progress,
        percentLabel: percentLabel,
        donaturLabel: donaturLabel,
        daysLeftLabel: daysLeftLabel,
      );

  SavedCampaign toSaved() => SavedCampaign(
        id: id,
        imageUrl: imageUrl,
        title: title,
        organizer: organizer,
        verified: verified,
        trustScore: trustScore,
        raisedLabel: raisedLabel,
        targetLabel: targetLabel,
        progress: progress,
        daysLeftLabel: daysLeftLabel,
        status: isTargetReached ? SavedStatus.completed : SavedStatus.active,
      );

  CampaignDetail toDetail() => CampaignDetail(
        id: id,
        imageUrl: imageUrl,
        category: category,
        location: location,
        title: title,
        organizer: organizer,
        organizerInitial: organizerInitial,
        verified: verified,
        trustScore: trustScore,
        raisedLabel: raisedLabel,
        targetLabel: targetLabel,
        progress: progress,
        percentLabel: percentLabel,
        donaturValue: donaturValue,
        daysLeftValue: daysLeftValue,
        description: description,
        rabItems: rabItems,
        milestones: milestones,
        onChainId: onChainId,
        explorerUrl: explorerUrl,
        isTargetReached: isTargetReached,
        canDonate: canDonate,
      );
}
