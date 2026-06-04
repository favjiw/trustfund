import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Tappable bookmark icon shown over campaign images and in app bars.
///
/// State styling:
/// - not saved: white outline (or dark outline on light surfaces)
/// - saved: filled black
class BookmarkButton extends StatelessWidget {
  final bool saved;
  final VoidCallback? onTap;

  /// When true the icon sits on a light/solid surface (e.g. an app bar), so the
  /// unsaved state uses a dark outline and no contrast shadow is drawn.
  final bool onLight;

  const BookmarkButton({
    super.key,
    this.saved = false,
    this.onTap,
    this.onLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = saved
        ? AppColors.black
        : (onLight ? AppColors.textPrimary : AppColors.white);

    final List<Shadow> shadows = onLight
        ? const []
        : [
            Shadow(
              color: saved ? const Color(0xCCFFFFFF) : const Color(0x73000000),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xs.w),
        child: Icon(
          saved ? Icons.bookmark : Icons.bookmark_border_rounded,
          color: color,
          size: 24.sp,
          shadows: shadows,
        ),
      ),
    );
  }
}
