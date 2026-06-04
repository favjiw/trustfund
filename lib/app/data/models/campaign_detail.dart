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
  });
}
