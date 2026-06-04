import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

/// Circular white bookmark toggle shown over a campaign image.
class BookmarkButton extends StatelessWidget {
  final bool saved;
  final VoidCallback? onTap;

  const BookmarkButton({super.key, this.saved = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          saved ? Icons.bookmark : Icons.bookmark_border_rounded,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
    );
  }
}