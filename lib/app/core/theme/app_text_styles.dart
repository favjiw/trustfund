import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale derived from the design's type spec.
///
/// Primary typeface is Plus Jakarta Sans (via google_fonts). If it cannot be
/// resolved, swap `_font` to `GoogleFonts.poppins` as the fallback.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _font({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size.sp,
      fontWeight: weight,
      height: lineHeight / size,
      color: color,
    );
  }

  // Header texts
  static TextStyle get h1Bold =>
      _font(size: 32, lineHeight: 48, weight: FontWeight.w700);
  static TextStyle get h1Medium =>
      _font(size: 32, lineHeight: 48, weight: FontWeight.w500);
  static TextStyle get h2Bold =>
      _font(size: 28, lineHeight: 40, weight: FontWeight.w700);
  static TextStyle get h2Medium =>
      _font(size: 28, lineHeight: 40, weight: FontWeight.w500);
  static TextStyle get h3Bold =>
      _font(size: 24, lineHeight: 32, weight: FontWeight.w700);
  static TextStyle get h3Medium =>
      _font(size: 24, lineHeight: 32, weight: FontWeight.w500);
  static TextStyle get h4Bold =>
      _font(size: 18, lineHeight: 24, weight: FontWeight.w700);
  static TextStyle get h4Medium =>
      _font(size: 18, lineHeight: 24, weight: FontWeight.w500);

  // Paragraph texts
  static TextStyle get p1Medium =>
      _font(size: 18, lineHeight: 24, weight: FontWeight.w500);
  static TextStyle get p1Regular =>
      _font(size: 18, lineHeight: 24, weight: FontWeight.w400);
  static TextStyle get p2Medium =>
      _font(size: 16, lineHeight: 24, weight: FontWeight.w500);
  static TextStyle get p2Regular =>
      _font(size: 16, lineHeight: 24, weight: FontWeight.w400);

  // Caption texts
  static TextStyle get c1Medium =>
      _font(size: 14, lineHeight: 24, weight: FontWeight.w500);
  static TextStyle get c1Regular =>
      _font(size: 14, lineHeight: 24, weight: FontWeight.w400);
  static TextStyle get c2Medium =>
      _font(size: 12, lineHeight: 24, weight: FontWeight.w500);
  static TextStyle get c2Regular =>
      _font(size: 12, lineHeight: 24, weight: FontWeight.w400);
}
