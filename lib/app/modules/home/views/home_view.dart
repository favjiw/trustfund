import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/category_chip.dart';
import '../../../widgets/impact_stat_card.dart';
import '../../../widgets/popular_campaign_card.dart';
import '../../../widgets/search_field.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/skeleton_box.dart';
import '../../../widgets/state_message.dart';
import '../../../widgets/urgent_campaign_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl.w,
            AppSpacing.md.h,
            AppSpacing.xl.w,
            AppSpacing.xxl.h,
          ),
          children: [
            _buildTitle(),
            SizedBox(height: AppSpacing.lg.h),
            _buildGreeting(),
            SizedBox(height: AppSpacing.lg.h),
            SearchField(
              onChanged: controller.onSearchChanged,
            ),
            SizedBox(height: AppSpacing.lg.h),
            _buildCategories(),
            SizedBox(height: AppSpacing.xxl.h),
            _buildFeed(),
            SizedBox(height: AppSpacing.xxl.h),
            _buildImpactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        'TrustFund',
        style: AppTextStyles.h4Bold.copyWith(
          color: AppColors.textPrimary,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => Text(
              'Hi, ${controller.userName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h3Bold.copyWith(
                color: AppColors.textPrimary,
                fontSize: 22.sp,
              ),
            ),
          ),
        ),
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 22.sp,
          ),
        ),
      ],
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

  Widget _buildFeed() {
    return Obx(() {
      if (controller.hasError.value) {
        return StateMessage.error(onRetry: controller.loadFeed);
      }
      final isLoading = controller.isLoading.value;
      final isEmpty = !isLoading &&
          controller.urgentCampaigns.isEmpty &&
          controller.popularCampaigns.isEmpty;
      if (isEmpty) {
        return const StateMessage.empty();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Mendesak! Butuh bantuan kamu.'),
          SizedBox(height: AppSpacing.lg.h),
          _buildUrgentList(),
          SizedBox(height: AppSpacing.xxl.h),
          SectionHeader(title: 'Kampanye Populer'),
          SizedBox(height: AppSpacing.lg.h),
          _buildPopularList(),
        ],
      );
    });
  }

  Widget _buildUrgentList() {
    return SizedBox(
      height: 270.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: 2,
            separatorBuilder: (_, __) => SizedBox(width: AppSpacing.lg.w),
            itemBuilder: (_, __) => _buildUrgentSkeleton(),
          );
        }
        final urgent = controller.filteredUrgentCampaigns;
        if (urgent.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: urgent.length,
          separatorBuilder: (_, __) => SizedBox(width: AppSpacing.lg.w),
          itemBuilder: (context, index) {
            final campaign = urgent[index];
            return UrgentCampaignCard(
              campaign: campaign,
              onTap: () => controller.openCampaign(campaign.id),
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Tidak ada kampanye yang cocok',
        style: AppTextStyles.c1Regular.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPopularList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          children: List.generate(2, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == 1 ? 0 : AppSpacing.lg.h,
              ),
              child: _buildPopularSkeleton(),
            );
          }),
        );
      }
      final popular = controller.filteredPopularCampaigns;
      if (popular.isEmpty) {
        return _buildEmptyState();
      }
      return Column(
        children: List.generate(popular.length, (index) {
          final campaign = popular[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == popular.length - 1 ? 0 : AppSpacing.lg.h,
            ),
            child: PopularCampaignCard(
              campaign: campaign,
              onDetail: () => controller.openCampaign(campaign.id),
            ),
          );
        }),
      );
    });
  }

  Widget _buildUrgentSkeleton() {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            height: 96.h,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 150.w, height: 14.h),
                SizedBox(height: AppSpacing.sm.h),
                SkeletonBox(width: 90.w, height: 12.h),
                SizedBox(height: AppSpacing.md.h),
                SkeletonBox(width: double.infinity, height: 8.h),
                SizedBox(height: AppSpacing.md.h),
                SkeletonBox(width: 120.w, height: 12.h),
                SizedBox(height: AppSpacing.sm.h),
                SkeletonBox(width: 70.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSkeleton() {
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
              SkeletonBox(width: 72.w, height: 72.w),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: double.infinity, height: 14.h),
                    SizedBox(height: AppSpacing.sm.h),
                    SkeletonBox(width: 140.w, height: 14.h),
                    SizedBox(height: AppSpacing.sm.h),
                    SkeletonBox(width: 90.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 120.w, height: 24.h),
              SkeletonBox(
                width: 90.w,
                height: 32.h,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: AppColors.impactBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -8.h,
            right: -8.w,
            child: ExcludeSemantics(
              child: Icon(
                Icons.shield,
                size: 96.sp,
                color: AppColors.shieldWatermark,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dampak TrustFund',
                style: AppTextStyles.h4Bold
                    .copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                'Bersama membangun transparansi dalam setiap rupiah yang Anda berikan.',
                style: AppTextStyles.c1Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: AppSpacing.lg.h),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ImpactStatCard(
                        value: 'Rp 12.8 M+',
                        label: 'Dana Terdistribusi',
                        valueColor: AppColors.success,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: ImpactStatCard(
                        value: '3,420+',
                        label: 'Kampanye Selesai',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              _buildFraudPill(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFraudPill() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: AppColors.success,
            size: 18.sp,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Text(
            'Fraud Rate: 0%',
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
