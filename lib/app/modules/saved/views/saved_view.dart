import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/placeholder_page.dart';
import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Tersimpan',
      subtitle: 'Kampanye yang kamu simpan akan muncul di sini.',
      icon: Icons.bookmark_border_rounded,
    );
  }
}
