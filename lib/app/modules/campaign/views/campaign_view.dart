import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/placeholder_page.dart';
import '../controllers/campaign_controller.dart';

class CampaignView extends GetView<CampaignController> {
  const CampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Kampanye',
      subtitle: 'Jelajahi semua kampanye penggalangan dana di sini.',
      icon: Icons.description_outlined,
    );
  }
}
