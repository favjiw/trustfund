import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Section title with a trailing "see all" arrow.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSeeAll,
          child: Icon(
            Icons.arrow_forward,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
