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
                if (controller.savedCampaigns.isEmpty) {
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
    final items = controller.visibleCampaigns;
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
        if (items.isEmpty)
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
          )
        else
          ...items.map(
            (campaign) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
              child: SavedCampaignCard(campaign: campaign),
            ),
          ),
      ],
    );
  }
}
