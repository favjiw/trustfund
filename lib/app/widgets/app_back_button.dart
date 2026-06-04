import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/theme/app_colors.dart';

/// Plain back arrow used in the top-left of secondary screens.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AppBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? Get.back,
      child: Icon(
        Icons.arrow_back,
        color: AppColors.textPrimary,
        size: 24.sp,
      ),
    );
  }
}
