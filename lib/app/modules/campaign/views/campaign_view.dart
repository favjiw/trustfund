import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/campaign_item_card.dart';
import '../../../widgets/category_chip.dart';
import '../../../widgets/search_field.dart';
import '../../../widgets/skeleton_box.dart';
import '../../../widgets/state_message.dart';
import '../controllers/campaign_controller.dart';

class CampaignView extends GetView<CampaignController> {
  const CampaignView({super.key});

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
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl.w,
                  AppSpacing.md.h,
                  AppSpacing.xl.w,
                  AppSpacing.xxl.h,
                ),
                children: [
                  SearchField(
                    hint: 'Cari kampanye...',
                    onChanged: controller.onSearchChanged,
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildCategories(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildResultRow(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildCampaignList(),
                ],
              ),
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
            Icons.arrow_back_rounded,
            size: 24.sp,
            color: AppColors.textPrimary,
          ),
          Expanded(
            child: Text(
              'Kampanye',
              textAlign: TextAlign.center,
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.primary),
            ),
          ),
          Icon(
            Icons.tune_rounded,
            size: 24.sp,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: List.generate(controller.categories.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == controller.categories.length - 1
                    ? 0
                    : AppSpacing.sm.w,
              ),
              child: CategoryChip(
                label: controller.categories[index],
                selected: controller.selectedCategory.value == index,
                onTap: () => controller.onCategorySelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCampaignList() {
    return Obx(() {
      if (controller.hasError.value) {
        return Padding(
          padding: EdgeInsets.only(top: AppSpacing.xxl.h),
          child: StateMessage.error(onRetry: controller.loadCampaigns),
        );
      }
      if (controller.isLoading.value) {
        return Column(
          children: List.generate(
            3,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
              child: _buildItemSkeleton(),
            ),
          ),
        );
      }
      if (controller.campaigns.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: AppSpacing.xxl.h),
          child: const StateMessage.empty(),
        );
      }
      final results = controller.filteredCampaigns;
      if (results.isEmpty) {
        return _buildEmptyState();
      }
      return Column(
        children: results
            .map(
              (campaign) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
                child: CampaignItemCard(
                  campaign: campaign,
                  onTap: () => Get.toNamed(
                    Routes.CAMPAIGN_DETAIL,
                    arguments: campaign.id,
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl.h),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48.sp,
            color: AppColors.iconMuted,
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'Tidak ada kampanye yang cocok',
            textAlign: TextAlign.center,
            style: AppTextStyles.p2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSkeleton() {
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
            height: 170.h,
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
                Row(
                  children: [
                    SkeletonBox(width: 32.w, height: 32.w, circle: true),
                    SizedBox(width: AppSpacing.sm.w),
                    SkeletonBox(width: 140.w, height: 14.h),
                  ],
                ),
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

  Widget _buildResultRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            controller.resultCountLabel,
            style: AppTextStyles.c1Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _openSortSheet,
          child: Row(
            children: [
              Obx(
                () => Text(
                  'Urutkan: ${controller.sortLabel}',
                  style: AppTextStyles.c1Medium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.xs.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSortSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg.r),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Urutkan kampanye',
                  style: AppTextStyles.h4Bold
                      .copyWith(color: AppColors.textPrimary),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            ...CampaignSort.values.map(_buildSortOption),
          ],
        ),
      ),
      isScrollControlled: false,
    );
  }

  Widget _buildSortOption(CampaignSort option) {
    return Obx(() {
      final selected = controller.sortOption.value == option;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          controller.onSortSelected(option);
          Get.back();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.md.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  CampaignController.labelForSort(option),
                  style: AppTextStyles.p2Regular.copyWith(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_rounded,
                  size: 20.sp,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      );
    });
  }
}
