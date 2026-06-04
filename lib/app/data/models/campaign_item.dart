/// Data model for a campaign shown in the vertical list on the Kampanye page.
class CampaignItem {
  final String id;
  final String imageUrl;
  final String category;
  final String title;
  final String organizer;
  final String organizerInitial;
  final bool verified;
  final int trustScore;
  final String raisedLabel;
  final String targetLabel;
  final double progress;
  final String percentLabel;
  final String donaturLabel;
  final String daysLeftLabel;

  const CampaignItem({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.organizer,
    required this.organizerInitial,
    required this.verified,
    required this.trustScore,
    required this.raisedLabel,
    required this.targetLabel,
    required this.progress,
    required this.percentLabel,
    required this.donaturLabel,
    required this.daysLeftLabel,
  });
}
