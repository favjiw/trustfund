import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Centralised popups for the app.
class AppDialogs {
  const AppDialogs._();

  /// Shows a "coming soon" popup for features that are not finished yet.
  /// Pass the [feature] name to personalise the message.
  static void comingSoon([String? feature]) {
    if (Get.isDialogOpen ?? false) return;

    final description = feature == null || feature.isEmpty
        ? 'Fitur ini belum selesai dan akan segera hadir.'
        : 'Fitur "$feature" belum selesai dan akan segera hadir.';

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction_rounded,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                'Segera Hadir',
                style: AppTextStyles.h4Bold
                    .copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.c1Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: AppSpacing.xl.h),
              PrimaryButton(label: 'Mengerti', onPressed: Get.back),
            ],
          ),
        ),
      ),
    );
  }
}
