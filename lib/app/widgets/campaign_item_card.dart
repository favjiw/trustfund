import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/campaign_item.dart';
import 'campaign_bookmark.dart';
import 'category_pill.dart';
import 'funding_summary_box.dart';
import 'initial_avatar.dart';
import 'network_image_box.dart';
import 'status_pill.dart';
import 'trust_score_pill.dart';
import 'verified_badge.dart';

/// Full-width campaign card for the vertical list on the Kampanye page.
class CampaignItemCard extends StatelessWidget {
  final CampaignItem campaign;
  final VoidCallback? onTap;

  const CampaignItemCard({super.key, required this.campaign, this.onTap});

  @override
  Widget build(BuildContext context) {
    final topRadius = BorderRadius.vertical(
      top: Radius.circular(AppSpacing.radiusLg.r),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
                  height: 170.h,
                  borderRadius: topRadius,
                ),
                Positioned(
                  top: AppSpacing.md.h,
                  left: AppSpacing.md.w,
                  child: const StatusPill.verifiedFund(),
                ),
                Positioned(
                  top: AppSpacing.md.h,
                  right: AppSpacing.md.w,
                  child: CategoryPill(label: campaign.category),
                ),
                Positioned(
                  bottom: AppSpacing.sm.h,
                  right: AppSpacing.sm.w,
                  child: CampaignBookmark(id: campaign.id),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h4Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Row(
                    children: [
                      InitialAvatar(letter: campaign.organizerInitial),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                campaign.organizer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.c1Regular.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            if (campaign.verified) ...[
                              SizedBox(width: AppSpacing.xs.w),
                              const VerifiedBadge(size: 14),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      TrustScorePill(
                        score: campaign.trustScore,
                        prefix: 'Trust',
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  FundingSummaryBox(
                    raisedLabel: campaign.raisedLabel,
                    targetLabel: campaign.targetLabel,
                    progress: campaign.progress,
                    percentLabel: campaign.percentLabel,
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IconLabel(
                        icon: Icons.people_alt_outlined,
                        label: campaign.donaturLabel,
                      ),
                      _IconLabel(
                        icon: Icons.access_time_rounded,
                        label: campaign.daysLeftLabel,
                      ),
                    ],
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

class _IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textSecondary),
        SizedBox(width: AppSpacing.xs.w),
        Text(
          label,
          style: AppTextStyles.c2Medium
              .copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
