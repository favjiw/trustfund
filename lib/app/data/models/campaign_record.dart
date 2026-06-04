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
  });

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
        status: progress >= 1.0 ? SavedStatus.completed : SavedStatus.active,
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
      );
}
