import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/campaign.dart';
import 'campaign_bookmark.dart';
import 'donation_progress_bar.dart';
import 'network_image_box.dart';
import 'verified_badge.dart';

/// Compact campaign card for the horizontal "Mendesak" carousel.
class UrgentCampaignCard extends StatelessWidget {
  final UrgentCampaign campaign;
  final VoidCallback? onTap;

  const UrgentCampaignCard({super.key, required this.campaign, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NetworkImageBox(
                  url: campaign.imageUrl,
                  height: 96.h,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusLg.r),
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm.h,
                  right: AppSpacing.sm.w,
                  child: CampaignBookmark(id: campaign.id),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.md.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.p2Medium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          campaign.organizer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.c2Regular
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      if (campaign.verified) ...[
                        SizedBox(width: AppSpacing.xs.w),
                        const VerifiedBadge(size: 12),
                      ],
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  DonationProgressBar(value: campaign.progress),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    campaign.raisedLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.c2Regular
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    campaign.daysLeftLabel,
                    style: AppTextStyles.c2Medium
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
