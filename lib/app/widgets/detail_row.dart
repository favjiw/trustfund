import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// A label/value row used in receipts and summaries. Pass [trailing] to render
/// a custom widget (e.g. a status pill) instead of plain [value] text.
class DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;

  const DetailRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.c1Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing ??
                  Text(
                    value ?? '',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.c1Medium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
