import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Selectable preset donation amount card (label on top, value below).
class NominalOptionCard extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback? onTap;

  const NominalOptionCard({
    super.key,
    required this.label,
    required this.value,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.infoBg : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.c2Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              value,
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
