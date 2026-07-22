import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/disbursement_tile.dart';
import '../../../widgets/donation_progress_bar.dart';
import '../../../widgets/info_banner.dart';
import '../../../widgets/network_image_box.dart';
import '../../../widgets/verified_badge.dart';
import '../controllers/track_donation_controller.dart';

class TrackDonationView extends GetView<TrackDonationController> {
  const TrackDonationView({super.key});

  @override
  Widget build(BuildContext context) {
    final receipt = controller.receipt;
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl.w,
                  AppSpacing.md.h,
                  AppSpacing.xl.w,
                  AppSpacing.xxl.h,
                ),
                children: [
                  _buildCampaignCard(receipt),
                  SizedBox(height: AppSpacing.xl.h),
                  _buildProgressHeader(),
                  SizedBox(height: AppSpacing.md.h),
                  Obx(() => DonationProgressBar(
                    value: controller.disbursedProgress.value,
                    color: AppColors.primary,
                  )),
                  SizedBox(height: AppSpacing.xl.h),
                  _buildTimeline(),
                  SizedBox(height: AppSpacing.lg.h),
                  const InfoBanner(
                    icon: Icons.lock_outline_rounded,
                    body: 'Setiap pencairan hanya terjadi setelah bukti '
                        'penggunaan dana divalidasi AI dan dieksekusi otomatis '
                        'oleh Smart Contract.',
                  ),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        children: [
          const AppBackButton(),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              'Lacak Donasi',
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(DonationReceipt receipt) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
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
                url: receipt.imageUrl,
                width: 56.w,
                height: 56.w,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.campaignTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.c1Medium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            receipt.organizer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.c2Regular
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        if (receipt.verified) ...[
                          SizedBox(width: AppSpacing.xs.w),
                          const VerifiedBadge(size: 12),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: AppSpacing.sm.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.summaryBoxBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            ),
            child: Row(
              children: [
                Text(
                  'Donasi Anda: ',
                  style: AppTextStyles.c1Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  receipt.formattedAmount,
                  style: AppTextStyles.c1Medium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Progres Penyaluran',
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
          ),
        ),
        Obx(() => Text(
          'Dana tersalurkan ${controller.disbursedPercentLabel.value}',
          style: AppTextStyles.c1Medium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        )),
      ],
    );
  }

  Widget _buildTimeline() {
    return Obx(() {
      if (controller.steps.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return Column(
        children: List.generate(controller.steps.length, (index) {
          return DisbursementTile(
            step: controller.steps[index],
            isLast: index == controller.steps.length - 1,
            onViewProof: () => controller.viewProof(index),
          );
        }),
      );
    });
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        AppSpacing.md.h,
        AppSpacing.xl.w,
        AppSpacing.lg.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight.h,
          child: OutlinedButton(
            onPressed: controller.backToHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
              ),
            ),
            child: Text(
              'Kembali ke Beranda',
              style: AppTextStyles.p2Medium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
