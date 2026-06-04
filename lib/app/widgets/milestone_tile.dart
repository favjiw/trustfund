import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/milestone_item.dart';

/// A single row in the campaign milestone timeline, with a status indicator,
/// a connecting line (hidden on the last item) and an optional status pill.
class MilestoneTile extends StatelessWidget {
  final MilestoneItem milestone;
  final bool isLast;

  const MilestoneTile({
    super.key,
    required this.milestone,
    this.isLast = false,
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
                  child: Container(
                    width: 2.w,
                    color: AppColors.divider,
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone.title,
                          style: AppTextStyles.c1Medium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          milestone.subtitle,
                          style: AppTextStyles.c2Regular
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (milestone.statusLabel != null) ...[
                    SizedBox(width: AppSpacing.sm.w),
                    _statusPill(),
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
    switch (milestone.status) {
      case MilestoneStatus.done:
        return Icon(
          Icons.check_circle,
          size: 22.sp,
          color: AppColors.success,
        );
      case MilestoneStatus.inProgress:
        return Container(
          width: 22.sp,
          height: 22.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Center(
            child: Container(
              width: 8.sp,
              height: 8.sp,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      case MilestoneStatus.upcoming:
        return Container(
          width: 22.sp,
          height: 22.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.border, width: 2),
          ),
        );
    }
  }

  Widget _statusPill() {
    final isDone = milestone.status == MilestoneStatus.done;
    final background = isDone ? AppColors.successBg : AppColors.infoBg;
    final foreground = isDone ? AppColors.success : AppColors.primary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
      ),
      child: Text(
        milestone.statusLabel!,
        style: AppTextStyles.c2Medium.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
