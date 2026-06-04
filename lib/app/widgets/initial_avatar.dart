import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Small circular avatar showing an organizer's initial letter.
class InitialAvatar extends StatelessWidget {
  final String letter;
  final double size;

  const InitialAvatar({super.key, required this.letter, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.pillBg,
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: AppTextStyles.c2Medium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
