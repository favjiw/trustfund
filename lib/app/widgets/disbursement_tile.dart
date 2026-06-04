import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/disbursement_step.dart';

/// A single step in the donation disbursement timeline (tracking page), with a
/// status indicator, connecting line, amount, status pill and optional detail
/// line plus a "Lihat Bukti" link.
class DisbursementTile extends StatelessWidget {
  final DisbursementStep step;
  final bool isLast;
  final VoidCallback? onViewProof;

  const DisbursementTile({
    super.key,
    required this.step,
    this.isLast = false,
    this.onViewProof,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _indicator(),
              if (!isLast)
                Expanded(
                  child: Container(width: 2.w, color: AppColors.divider),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: AppTextStyles.c1Medium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Text(
                        step.amount,
                        style: AppTextStyles.c1Medium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  _statusPill(),
                  if (step.detail != null) ...[
                    SizedBox(height: AppSpacing.sm.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.fingerprint_rounded,
                          size: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.xs.w),
                        Expanded(
                          child: Text(
                            step.detail!,
                            style: AppTextStyles.c2Regular
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (step.hasProof) ...[
                    SizedBox(height: AppSpacing.sm.h),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onViewProof,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat Bukti',
                            style: AppTextStyles.c1Medium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator() {
    switch (step.status) {
      case DisbursementStatus.disbursed:
        return Icon(Icons.check_circle, size: 24.sp, color: AppColors.success);
      case DisbursementStatus.reviewing:
        return Container(
          width: 24.sp,
          height: 24.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.warningBg,
            border: Border.all(color: AppColors.warning, width: 2),
          ),
          child: Icon(
            Icons.hourglass_top_rounded,
            size: 14.sp,
            color: AppColors.warning,
          ),
        );
      case DisbursementStatus.waiting:
        return Container(
          width: 24.sp,
          height: 24.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.summaryBoxBg,
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 13.sp,
            color: AppColors.textSecondary,
          ),
        );
    }
  }

  Widget _statusPill() {
    late final Color background;
    late final Color foreground;
    late final IconData icon;
    switch (step.status) {
      case DisbursementStatus.disbursed:
        background = AppColors.successBg;
        foreground = AppColors.success;
        icon = Icons.verified_outlined;
        break;
      case DisbursementStatus.reviewing:
        background = AppColors.warningBg;
        foreground = AppColors.warning;
        icon = Icons.sync_rounded;
        break;
      case DisbursementStatus.waiting:
        background = AppColors.summaryBoxBg;
        foreground = AppColors.textSecondary;
        icon = Icons.lock_outline_rounded;
        break;
    }
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
          Icon(icon, size: 14.sp, color: foreground),
          SizedBox(width: AppSpacing.xs.w),
          Text(
            step.statusLabel,
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
