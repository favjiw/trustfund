import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/repositories/campaign_repository.dart';
import 'bookmark_button.dart';

/// Bookmark control wired to the shared saved store. Reading [isSaved] inside
/// [Obx] keeps every instance (cards, detail) in sync as the user saves or
/// unsaves a campaign anywhere in the app.
class CampaignBookmark extends StatelessWidget {
  final String id;
  final bool onLight;

  const CampaignBookmark({super.key, required this.id, this.onLight = false});

  @override
  Widget build(BuildContext context) {
    final repository = CampaignRepository.instance;
    return Obx(
      () => BookmarkButton(
        saved: repository.isSaved(id),
        onTap: () => repository.toggleSaved(id),
        onLight: onLight,
      ),
    );
  }
}
