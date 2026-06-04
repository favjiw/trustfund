import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// A read-only value box with a copy control. Used for virtual-account numbers
/// and on-chain transaction hashes. When [actionLabel] is set the trailing
/// control renders as a labelled pill, otherwise as a plain icon button.
class CopyField extends StatelessWidget {
  final String? label;
  final String value;
  final String? actionLabel;
  final VoidCallback? onCopy;
  final Color background;

  const CopyField({
    super.key,
    required this.value,
    this.label,
    this.actionLabel,
    this.onCopy,
    this.background = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null) ...[
                  Text(
                    label!,
                    style: AppTextStyles.c2Medium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                ],
                Text(
                  value,
                  style: AppTextStyles.p2Medium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          _buildAction(),
        ],
      ),
    );
  }

  Widget _buildAction() {
    if (actionLabel == null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onCopy,
        child: Icon(
          Icons.copy_rounded,
          size: 20.sp,
          color: AppColors.textSecondary,
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onCopy,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.summaryBoxBg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.copy_rounded, size: 16.sp, color: AppColors.primary),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              actionLabel!,
              style: AppTextStyles.c1Medium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
