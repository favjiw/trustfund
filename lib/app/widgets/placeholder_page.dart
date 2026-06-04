import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Simple centered placeholder used by tabs that are not designed yet.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xxl.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64.sp, color: AppColors.primary),
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4Bold
                      .copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.c1Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
