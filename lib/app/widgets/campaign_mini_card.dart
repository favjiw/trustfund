import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'network_image_box.dart';
import 'status_pill.dart';

/// Compact campaign summary card shown at the top of the donation page.
class CampaignMiniCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String organizer;
  final bool verified;

  const CampaignMiniCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.organizer,
    this.verified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.summaryBoxBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageBox(
            url: imageUrl,
            width: 56.w,
            height: 56.w,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (verified) ...[
                  const StatusPill(
                    label: 'VERIFIED',
                    icon: Icons.verified,
                    background: AppColors.verifiedFundBg,
                    foreground: AppColors.success,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                ],
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h4Bold
                      .copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  organizer,
                  style: AppTextStyles.c1Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
