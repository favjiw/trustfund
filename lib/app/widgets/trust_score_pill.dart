import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Light pill showing a campaign trust score, e.g. "Trust Score: 98".
class TrustScorePill extends StatelessWidget {
  final int score;
  final String prefix;

  const TrustScorePill({
    super.key,
    required this.score,
    this.prefix = 'Trust Score',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
      ),
      child: Text(
        '$prefix: $score',
        style: AppTextStyles.c2Medium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
