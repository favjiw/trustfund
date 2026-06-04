import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Title + subtitle block used at the top of the auth screens.
/// `large` switches between the big landing title and the smaller flow title.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool large;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.large = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: large ? AppTextStyles.h1Bold : AppTextStyles.h3Bold,
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          subtitle,
          style: AppTextStyles.p2Regular.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
