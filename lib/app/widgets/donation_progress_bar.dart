import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

/// Thin rounded progress bar for a campaign's funding progress.
///
/// Built from plain containers (instead of [LinearProgressIndicator]) to avoid
/// a Flutter semantics assertion (`!semantics.parentDataDirty`) that the
/// Material progress indicators can trigger during the semantics flush.
class DonationProgressBar extends StatelessWidget {
  final double value;
  final Color? color;

  const DonationProgressBar({super.key, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    // A negative value signals "funding progress unknown" (the list/detail API
    // does not expose a reliable raised amount) — render nothing in that case.
    if (value < 0) return const SizedBox.shrink();
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 6.h,
        width: double.infinity,
        color: AppColors.progressTrack,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: clamped,
            child: Container(color: color ?? AppColors.primary),
          ),
        ),
      ),
    );
  }
}
