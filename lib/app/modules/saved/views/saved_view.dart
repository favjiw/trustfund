import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/empty_state_view.dart';
import '../../../widgets/network_image_box.dart';
import '../../../widgets/saved_campaign_card.dart';
import '../../../widgets/segmented_tabs.dart';
import '../../../widgets/skeleton_box.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

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
                if (!controller.isLoading.value &&
                    controller.savedCampaigns.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.bookmark_border_rounded,
                    title: 'Belum ada kampanye tersimpan',
                    subtitle:
                        'Simpan kampanye yang menarik agar mudah dipantau di sini.',
                    buttonLabel: 'Jelajahi Kampanye',
                    onButtonPressed: controller.goToCampaigns,
                  );
                }
                return _buildList();
              }),
            ),
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
          Icon(
            Icons.menu_rounded,
            size: 24.sp,
            color: AppColors.textPrimary,
          ),
          Expanded(
            child: Text(
              'Tersimpan',
              textAlign: TextAlign.center,
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.primary),
            ),
          ),
          _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    String url = '';
    if (Get.isRegistered<ProfileController>()) {
      url = Get.find<ProfileController>().avatarUrl;
    }
    if (url.isEmpty) {
      return SizedBox(width: 32.w);
    }
    return NetworkImageBox(
      url: url,
      width: 32.w,
      height: 32.w,
      borderRadius: BorderRadius.circular(32.r),
    );
  }

  Widget _buildList() {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        AppSpacing.sm.h,
        AppSpacing.xl.w,
        AppSpacing.xxl.h,
      ),
      children: [
        Text(
          controller.subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.c1Regular
              .copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSpacing.lg.h),
        SegmentedTabs(
          labels: controller.filters,
          selectedIndex: controller.selectedFilter.value,
          onChanged: controller.onFilterSelected,
        ),
        SizedBox(height: AppSpacing.lg.h),
        if (controller.isLoading.value)
          ...List.generate(
            3,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
              child: _buildCardSkeleton(),
            ),
          )
        else
          ..._buildCampaignCards(),
      ],
    );
  }

  List<Widget> _buildCampaignCards() {
    final items = controller.visibleCampaigns;
    if (items.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.only(top: AppSpacing.huge.h),
          child: Center(
            child: Text(
              'Tidak ada kampanye pada kategori ini.',
              textAlign: TextAlign.center,
              style: AppTextStyles.c1Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ];
    }
    return items
        .map(
          (campaign) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
            child: SavedCampaignCard(
              campaign: campaign,
              onDetail: () => controller.openDetail(campaign.id),
            ),
          ),
        )
        .toList();
  }

  Widget _buildCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            height: 150.h,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: double.infinity, height: 16.h),
                SizedBox(height: AppSpacing.sm.h),
                SkeletonBox(width: 200.w, height: 16.h),
                SizedBox(height: AppSpacing.md.h),
                SkeletonBox(width: 140.w, height: 14.h),
                SizedBox(height: AppSpacing.md.h),
                SkeletonBox(
                  width: double.infinity,
                  height: 64.h,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                SizedBox(height: AppSpacing.md.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonBox(width: 100.w, height: 14.h),
                    SkeletonBox(width: 80.w, height: 14.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
