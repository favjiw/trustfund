import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Compact dark "Detail" action button used on campaign cards.
class DetailButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const DetailButton({super.key, this.label = 'Detail', this.onPressed});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return Material(
      color: AppColors.detailButton,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl.w,
            vertical: AppSpacing.md.h,
          ),
          child: Text(
            label,
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
