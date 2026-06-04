import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// A single tappable row inside a [ProfileMenuSection].
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.h,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: AppColors.label),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.p2Regular
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: AppSpacing.sm.w),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 22.sp,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}
