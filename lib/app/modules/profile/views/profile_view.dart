import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/placeholder_page.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Profil',
      subtitle: 'Kelola akun dan riwayat donasimu di sini.',
      icon: Icons.person_outline_rounded,
    );
  }
}
