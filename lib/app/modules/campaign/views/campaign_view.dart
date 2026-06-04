import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/campaign_item_card.dart';
import '../../../widgets/category_chip.dart';
import '../../../widgets/search_field.dart';
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
                    controller: controller.searchController,
                    hint: 'Cari kampanye...',
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildCategories(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildResultRow(),
                  SizedBox(height: AppSpacing.lg.h),
                  ...controller.campaigns.map(
                    (campaign) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
                      child: CampaignItemCard(campaign: campaign),
                    ),
                  ),
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
    return Obx(
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
    );
  }

  Widget _buildResultRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.resultCountLabel,
          style: AppTextStyles.c1Regular
              .copyWith(color: AppColors.textSecondary),
        ),
        Row(
          children: [
            Text(
              'Urutkan: ${controller.sortLabel}',
              style: AppTextStyles.c1Medium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
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
      ],
    );
  }
}
