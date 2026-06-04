import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/campaign.dart';
import 'detail_button.dart';
import 'network_image_box.dart';
import 'verified_badge.dart';

/// Wide campaign card for the vertical "Kampanye Populer" list.
class PopularCampaignCard extends StatelessWidget {
  final PopularCampaign campaign;
  final VoidCallback? onDetail;

  const PopularCampaignCard({super.key, required this.campaign, this.onDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageBox(
                url: campaign.imageUrl,
                width: 72.w,
                height: 72.w,
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.title,
                      maxLines: 2,
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
                            style: AppTextStyles.c1Regular
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        if (campaign.verified) ...[
                          SizedBox(width: AppSpacing.xs.w),
                          const VerifiedBadge(size: 14),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.donaturLabel,
                      style: AppTextStyles.c2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      campaign.amountLabel,
                      style: AppTextStyles.h4Bold
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              DetailButton(onPressed: onDetail),
            ],
          ),
        ],
      ),
    );
  }
}
