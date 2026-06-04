import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Soft green information banner (e.g. blockchain transparency or smart-contract
/// notices) with a leading icon, body text and an optional action link.
class InfoBanner extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const InfoBanner({
    super.key,
    required this.icon,
    required this.body,
    this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.success),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTextStyles.c1Medium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                ],
                Text(
                  body,
                  style: AppTextStyles.c2Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (actionLabel != null) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: AppTextStyles.c2Medium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
