import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/rab_item.dart';

/// Two-column budget table (Item / Estimasi) used on the campaign detail page.
class RabTable extends StatelessWidget {
  final List<RabItem> items;

  const RabTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _header(),
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                _row(item),
                if (index != items.length - 1)
                  Divider(height: 1, thickness: 1, color: AppColors.divider),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Item',
              style: AppTextStyles.c2Medium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Estimasi',
            style: AppTextStyles.c2Medium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(RabItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: AppTextStyles.c1Regular
                  .copyWith(color: AppColors.textPrimary),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Text(
            item.estimate,
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
