/// Progress state of a campaign milestone.
enum MilestoneStatus { done, inProgress, upcoming }

/// A single step in a campaign's milestone timeline.
class MilestoneItem {
  final String title;
  final String subtitle;
  final MilestoneStatus status;

  const MilestoneItem({
    required this.title,
    required this.subtitle,
    required this.status,
  });

  String? get statusLabel {
    switch (status) {
      case MilestoneStatus.done:
        return 'SELESAI';
      case MilestoneStatus.inProgress:
        return 'SEDANG BERJALAN';
      case MilestoneStatus.upcoming:
        return null;
    }
  }
}
