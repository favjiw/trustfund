import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'profile_menu_tile.dart';

/// A titled group of [ProfileMenuTile]s rendered inside a white card with
/// dividers between rows.
class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuTile> tiles;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xs.w,
            bottom: AppSpacing.sm.h,
          ),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.c2Medium.copyWith(
              color: AppColors.sectionLabel,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: _withDividers(),
          ),
        ),
      ],
    );
  }

  List<Widget> _withDividers() {
    final children = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      children.add(tiles[i]);
      if (i != tiles.length - 1) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.lg.w,
            endIndent: AppSpacing.lg.w,
            color: AppColors.divider,
          ),
        );
      }
    }
    return children;
  }
}