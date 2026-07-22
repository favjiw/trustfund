import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/campaign_detail.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/campaign_bookmark.dart';
import '../../../widgets/category_pill.dart';
import '../../../widgets/donation_progress_bar.dart';
import '../../../widgets/donor_network_graph.dart';
import '../../../widgets/info_banner.dart';
import '../../../widgets/milestone_tile.dart';
import '../../../widgets/network_image_box.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/rab_table.dart';
import '../../../widgets/skeleton_box.dart';
import '../../../widgets/state_message.dart';
import '../../../widgets/status_pill.dart';
import '../../../widgets/trust_score_pill.dart';
import '../../../widgets/underline_tabs.dart';
import '../../../widgets/verified_badge.dart';
import '../controllers/campaign_detail_controller.dart';

class CampaignDetailView extends GetView<CampaignDetailController> {
  const CampaignDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Obx(() {
                if (controller.hasError.value) {
                  return StateMessage.error(onRetry: controller.loadDetail);
                }
                if (controller.isLoading.value) {
                  return _buildDetailSkeleton();
                }
                final detail = controller.detail.value;
                if (detail == null) {
                  return const StateMessage.empty();
                }
                return _buildContent(detail);
              }),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(CampaignDetail detail) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeroImage(detail),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl.w,
            AppSpacing.lg.h,
            AppSpacing.xl.w,
            AppSpacing.xxl.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleBlock(detail),
              SizedBox(height: AppSpacing.lg.h),
              _buildFunding(detail),
              SizedBox(height: AppSpacing.lg.h),
              _buildStatsRow(detail),
              SizedBox(height: AppSpacing.xl.h),
              Obx(
                () => UnderlineTabs(
                  labels: controller.tabs,
                  selectedIndex: controller.selectedTab.value,
                  onChanged: controller.onTabSelected,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Obx(() => _buildTabContent(detail)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSkeleton() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: SkeletonBox(
            height: 200.h,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl.w,
            AppSpacing.lg.h,
            AppSpacing.xl.w,
            AppSpacing.xxl.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: double.infinity, height: 22.h),
              SizedBox(height: AppSpacing.sm.h),
              SkeletonBox(width: 220.w, height: 22.h),
              SizedBox(height: AppSpacing.lg.h),
              SkeletonBox(
                width: double.infinity,
                height: 52.h,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
              ),
              SizedBox(height: AppSpacing.lg.h),
              SkeletonBox(width: 180.w, height: 24.h),
              SizedBox(height: AppSpacing.md.h),
              SkeletonBox(width: double.infinity, height: 8.h),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                children: [
                  Expanded(
                    child: SkeletonBox(
                      height: 56.h,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd.r),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: SkeletonBox(
                      height: 56.h,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl.h),
              SkeletonBox(width: double.infinity, height: 14.h),
              SizedBox(height: AppSpacing.sm.h),
              SkeletonBox(width: double.infinity, height: 14.h),
              SizedBox(height: AppSpacing.sm.h),
              SkeletonBox(width: 240.w, height: 14.h),
            ],
          ),
        ),
      ],
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
              'Detail Kampanye',
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Icon(Icons.share_outlined, size: 22.sp, color: AppColors.textPrimary),
          SizedBox(width: AppSpacing.sm.w),
          Obx(() {
            final detail = controller.detail.value;
            if (detail == null) {
              return Icon(
                Icons.bookmark_border_rounded,
                size: 22.sp,
                color: AppColors.textPrimary,
              );
            }
            return CampaignBookmark(id: detail.id, onLight: true);
          }),
        ],
      ),
    );
  }

  Widget _buildHeroImage(CampaignDetail detail) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
      child: Stack(
        children: [
          NetworkImageBox(
            url: detail.imageUrl,
            height: 200.h,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
          ),
          Positioned(
            left: AppSpacing.md.w,
            bottom: AppSpacing.md.h,
            child: Row(
              children: [
                const StatusPill.verifiedFund(),
                SizedBox(width: AppSpacing.sm.w),
                StatusPill(
                  label: detail.location,
                  icon: Icons.location_on,
                  background: AppColors.white,
                  foreground: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBlock(CampaignDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.title,
          style: AppTextStyles.h3Bold.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.md.h),
        Container(
          padding: EdgeInsets.all(AppSpacing.md.w),
          decoration: BoxDecoration(
            color: AppColors.summaryBoxBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 18.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        detail.organizer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.c1Medium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (detail.verified) ...[
                      SizedBox(width: AppSpacing.xs.w),
                      const VerifiedBadge(size: 14),
                    ],
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              TrustScorePill(score: detail.trustScore, prefix: 'Trust Score'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunding(CampaignDetail detail) {
    return Column(
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
                    detail.raisedLabel,
                    style: AppTextStyles.h3Bold
                        .copyWith(color: AppColors.primary),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    detail.targetLabel,
                    style: AppTextStyles.c2Regular
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Text(
              detail.percentLabel,
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.success),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        DonationProgressBar(value: detail.progress, color: AppColors.success),
      ],
    );
  }

  Widget _buildStatsRow(CampaignDetail detail) {
    return Row(
      children: [
        Expanded(
          child: _statBox(
            icon: Icons.people_alt_outlined,
            label: 'Donatur',
            value: detail.donaturValue,
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: _statBox(
            icon: Icons.access_time_rounded,
            label: 'Sisa Waktu',
            value: detail.daysLeftValue,
          ),
        ),
      ],
    );
  }

  Widget _statBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.summaryBoxBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.c2Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: AppTextStyles.c1Medium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(CampaignDetail detail) {
    switch (controller.selectedTab.value) {
      case 1:
        return _buildRabTab(detail);
      case 2:
        return _buildMilestoneTab(detail);
      case 3:
        return _buildDonaturTab();
      default:
        return _buildDetailTab(detail);
    }
  }

  Widget _buildDetailTab(CampaignDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...detail.description.map(
          (paragraph) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: Text(
              paragraph,
              style: AppTextStyles.p2Regular.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        InfoBanner(
          icon: Icons.shield_outlined,
          title: 'Transparansi Blockchain Aktif',
          body: 'Semua transaksi tercatat di blockchain untuk keamanan dan '
              'akuntabilitas publik.',
          actionLabel: detail.explorerUrl.isEmpty
              ? null
              : 'LIHAT BUKTI DI EXPLORER',
          onAction: controller.openExplorer,
        ),
      ],
    );
  }

  Widget _buildRabTab(CampaignDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Rencana Anggaran (RAB)',
                style: AppTextStyles.h4Bold
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
            const CategoryPill(
              label: 'HARGA WAJAR',
              background: AppColors.successBg,
              foreground: AppColors.success,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        RabTable(items: detail.rabItems),
      ],
    );
  }

  Widget _buildMilestoneTab(CampaignDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestone Kampanye',
          style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.lg.h),
        ...List.generate(detail.milestones.length, (index) {
          return MilestoneTile(
            milestone: detail.milestones[index],
            isLast: index == detail.milestones.length - 1,
          );
        }),
      ],
    );
  }

  Widget _buildDonaturTab() {
    if (controller.graphError.value) {
      return StateMessage.error(onRetry: controller.loadDonorGraph);
    }
    final graph = controller.donorGraph.value;
    if (controller.isGraphLoading.value || graph == null) {
      return Column(
        children: [
          SkeletonBox(
            height: 300.h,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
          ),
          SizedBox(height: AppSpacing.lg.h),
          SkeletonBox(width: 240.w, height: 28.h),
        ],
      );
    }
    return DonorNetworkGraph(graph: graph);
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
        child: Row(
          children: [
            _buildDonorAvatars(),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Obx(() {
                final detail = controller.detail.value;
                final canDonate = detail?.canDonate ?? false;
                return PrimaryButton(
                  label: !canDonate && detail != null
                      ? (detail.isTargetReached
                          ? 'Target Tercapai'
                          : 'Donasi Ditutup')
                      : 'Donasi Sekarang',
                  onPressed: controller.isLoading.value ||
                          controller.hasError.value ||
                          detail == null ||
                          !canDonate
                      ? null
                      : controller.goToDonation,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorAvatars() {
    const urls = [
      'https://randomuser.me/api/portraits/women/68.jpg',
      'https://randomuser.me/api/portraits/men/75.jpg',
    ];
    return SizedBox(
      width: 52.w,
      height: 36.w,
      child: Stack(
        children: List.generate(urls.length, (index) {
          return Positioned(
            left: index * 20.w,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: NetworkImageBox(
                url: urls[index],
                width: 32.w,
                height: 32.w,
                borderRadius: BorderRadius.circular(32.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
