import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Small rounded status pill with a leading icon (e.g. "Terverifikasi",
/// "Selesai", "Verified Fund").
class StatusPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  const StatusPill({
    super.key,
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  const StatusPill.verified({super.key})
      : label = 'Terverifikasi',
        icon = Icons.verified,
        background = AppColors.successBg,
        foreground = AppColors.success;

  const StatusPill.done({super.key})
      : label = 'Selesai',
        icon = Icons.check_circle,
        background = AppColors.successBg,
        foreground = AppColors.success;

  const StatusPill.verifiedFund({super.key})
      : label = 'Verified Fund',
        icon = Icons.verified,
        background = AppColors.verifiedFundBg,
        foreground = AppColors.success;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 14.sp),
          SizedBox(width: AppSpacing.xs.w),
          Text(
            label,
            style: AppTextStyles.c2Medium.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
