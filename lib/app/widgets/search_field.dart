import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Rounded search field with a trailing magnifier icon.
class SearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    this.hint = 'Cari donasi...',
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.p2Regular.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.white,
        hintText: hint,
        hintStyle: AppTextStyles.p2Regular.copyWith(color: AppColors.hint),
        suffixIcon: Icon(
          Icons.search,
          color: AppColors.iconMuted,
          size: 22.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.lg.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
