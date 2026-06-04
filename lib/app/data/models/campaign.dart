/// Data model for an "urgent" campaign shown in the horizontal carousel.
class UrgentCampaign {
  final String imageUrl;
  final String title;
  final String organizer;
  final bool verified;
  final String raisedLabel;
  final String daysLeftLabel;
  final double progress;

  const UrgentCampaign({
    required this.imageUrl,
    required this.title,
    required this.organizer,
    required this.verified,
    required this.raisedLabel,
    required this.daysLeftLabel,
    required this.progress,
  });
}

/// Data model for a "popular" campaign shown in the vertical list.
class PopularCampaign {
  final String imageUrl;
  final String title;
  final String organizer;
  final bool verified;
  final String donaturLabel;
  final String amountLabel;

  const PopularCampaign({
    required this.imageUrl,
    required this.title,
    required this.organizer,
    required this.verified,
    required this.donaturLabel,
    required this.amountLabel,
  });
}
