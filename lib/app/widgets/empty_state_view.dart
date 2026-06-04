import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'primary_button.dart';

/// Centered empty-state with a soft icon, title, subtitle and a CTA button.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: 48.sp, color: AppColors.primary),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style:
              AppTextStyles.h3Bold.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.p2Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
              child: PrimaryButton(
                label: buttonLabel,
                onPressed: onButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}