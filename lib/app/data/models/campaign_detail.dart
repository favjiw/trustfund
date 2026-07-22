import 'milestone_item.dart';
import 'rab_item.dart';

/// Rich data model backing the campaign detail page.
class CampaignDetail {
  final String id;
  final String imageUrl;
  final String category;
  final String location;
  final String title;
  final String organizer;
  final String organizerInitial;
  final bool verified;
  final int trustScore;
  final String raisedLabel;
  final String targetLabel;
  final double progress;
  final String percentLabel;
  final String donaturValue;
  final String daysLeftValue;
  final List<String> description;
  final List<RabItem> rabItems;
  final List<MilestoneItem> milestones;

  /// On-chain id (e.g. "CMP-...") of the campaign, for the proof banner.
  final String onChainId;

  /// Blockchain explorer URL for the campaign's creation transaction. Empty
  /// when the campaign has no on-chain record yet.
  final String explorerUrl;

  /// Whether the funding target has been reached.
  final bool isTargetReached;

  /// Whether the API still accepts donations; drives the donate button.
  final bool canDonate;

  const CampaignDetail({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.title,
    required this.organizer,
    required this.organizerInitial,
    required this.verified,
    required this.trustScore,
    required this.raisedLabel,
    required this.targetLabel,
    required this.progress,
    required this.percentLabel,
    required this.donaturValue,
    required this.daysLeftValue,
    required this.description,
    required this.rabItems,
    required this.milestones,
    this.onChainId = '',
    this.explorerUrl = '',
    this.isTargetReached = false,
    this.canDonate = true,
  });
}
