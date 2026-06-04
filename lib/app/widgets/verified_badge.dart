import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

/// Small blue verified seal shown next to an organizer name.
class VerifiedBadge extends StatelessWidget {
  final double size;
  const VerifiedBadge({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified,
      color: AppColors.primary,
      size: size.sp,
    );
  }
}
