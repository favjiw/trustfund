import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// White stat tile (value + label) used inside the impact section.
class ImpactStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const ImpactStatCard({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.h3Bold.copyWith(color: valueColor),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            label,
            style: AppTextStyles.c1Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
