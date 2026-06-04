import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'donation_progress_bar.dart';

/// Light box summarising a campaign's funding: amount raised, target, an
/// optional percentage, and a progress bar.
class FundingSummaryBox extends StatelessWidget {
  final String raisedLabel;
  final String targetLabel;
  final double progress;
  final String? percentLabel;

  const FundingSummaryBox({
    super.key,
    required this.raisedLabel,
    required this.targetLabel,
    required this.progress,
    this.percentLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.summaryBoxBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      raisedLabel,
                      style: AppTextStyles.h4Bold
                          .copyWith(color: AppColors.primary),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      targetLabel,
                      style: AppTextStyles.c2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (percentLabel != null) ...[
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  percentLabel!,
                  style: AppTextStyles.c1Medium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          DonationProgressBar(value: progress, color: AppColors.success),
        ],
      ),
    );
  }
}