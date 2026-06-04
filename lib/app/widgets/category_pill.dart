import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// White rounded category tag shown over a campaign image (e.g. "Pendidikan").
class CategoryPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const CategoryPill({
    super.key,
    required this.label,
    this.background = AppColors.white,
    this.foreground = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.c2Medium.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}