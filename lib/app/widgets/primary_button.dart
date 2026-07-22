import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Primary call-to-action button. Defaults to the brand gradient; pass
/// `gradient: false` for a flat solid-blue variant.
///
/// When [isLoading] is `true` the label is replaced with a small spinner
/// and taps are disabled.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool gradient;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.gradient = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    final disabled = onPressed == null && !isLoading;
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient && !disabled ? AppColors.primaryGradient : null,
          color: disabled
              ? AppColors.textSecondary.withValues(alpha: 0.35)
              : (gradient ? null : AppColors.primary),
          borderRadius: radius,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: AppTextStyles.p2Medium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
