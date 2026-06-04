/// Whether a saved campaign is still running or has finished.
enum SavedStatus { active, completed }

/// Data model for a campaign shown on the Tersimpan (saved) page.
class SavedCampaign {
  final String id;
  final String imageUrl;
  final String title;
  final String organizer;
  final bool verified;
  final int trustScore;
  final String raisedLabel;
  final String targetLabel;
  final double progress;
  final String daysLeftLabel;
  final SavedStatus status;

  const SavedCampaign({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.organizer,
    required this.verified,
    required this.trustScore,
    required this.raisedLabel,
    required this.targetLabel,
    required this.progress,
    required this.daysLeftLabel,
    this.status = SavedStatus.active,
  });

  bool get isCompleted => status == SavedStatus.completed;
}
