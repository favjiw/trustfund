import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/saved_campaign.dart';
import 'bookmark_button.dart';
import 'funding_summary_box.dart';
import 'network_image_box.dart';
import 'status_pill.dart';
import 'trust_score_pill.dart';
import 'verified_badge.dart';

/// Card for a single saved campaign on the Tersimpan page.
class SavedCampaignCard extends StatelessWidget {
  final SavedCampaign campaign;
  final VoidCallback? onDetail;
  final VoidCallback? onReport;
  final VoidCallback? onBookmark;

  const SavedCampaignCard({
    super.key,
    required this.campaign,
    this.onDetail,
    this.onReport,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final topRadius = BorderRadius.vertical(
      top: Radius.circular(AppSpacing.radiusLg.r),
    );

    return Container(
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
                height: 150.h,
                borderRadius: topRadius,
              ),
              Positioned(
                top: AppSpacing.md.h,
                left: AppSpacing.md.w,
                child: campaign.isCompleted
                    ? const StatusPill.done()
                    : const StatusPill.verifiedFund(),
              ),
              Positioned(
                top: AppSpacing.md.h,
                right: AppSpacing.md.w,
                child: BookmarkButton(saved: true, onTap: onBookmark),
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
                SizedBox(height: AppSpacing.sm.h),
                Row(
                  children: [
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
                    TrustScorePill(score: campaign.trustScore),
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
                if (campaign.isCompleted)
                  _buildCompletedFooter()
                else ...[
                  FundingSummaryBox(
                    raisedLabel: campaign.raisedLabel,
                    targetLabel: campaign.targetLabel,
                    progress: campaign.progress,
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  _buildActiveFooter(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              campaign.daysLeftLabel,
              style: AppTextStyles.c2Medium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDetail,
          child: Text(
            'Detail',
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Target Tercapai Penuh',
          style: AppTextStyles.c1Medium.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onReport,
          child: Text(
            'Lihat Laporan',
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}