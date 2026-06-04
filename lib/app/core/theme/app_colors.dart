import 'package:flutter/material.dart';

/// Central color palette for the app. Reference these instead of hardcoding hex.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF4F7BF7);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryLight, primary],
  );

  // Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F1729);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color label = Color(0xFF1F2937);
  static const Color hint = Color(0xFF9CA3AF);

  // Lines & icons
  static const Color border = Color(0xFFE5E7EB);
  static const Color fieldFill = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color iconMuted = Color(0xFF9CA3AF);

  // Brand marks
  static const Color facebook = Color(0xFF1877F2);

  // Home / dashboard
  static const Color homeBackground = Color(0xFFF5F5FB);
  static const Color detailButton = Color(0xFF434B6E);
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFE7F7EE);
  static const Color impactBackground = Color(0xFFEAEAF3);
  static const Color navInactive = Color(0xFF9CA3AF);
  static const Color shieldWatermark = Color(0xFFD9D9E8);
  static const Color imagePlaceholder = Color(0xFFEDEDF2);

  // Cards, pills & lists
  static const Color darkCard = Color(0xFF3B4470);
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF464F86), Color(0xFF333B61)],
  );
  static const Color onDarkCard = Color(0xFFFFFFFF);
  static const Color onDarkCardMuted = Color(0xFFB7BCD8);
  static const Color onDarkCardDivider = Color(0x33FFFFFF);

  static const Color summaryBoxBg = Color(0xFFF3F4FA);
  static const Color pillBg = Color(0xFFEDEEF6);
  static const Color verifiedFundBg = Color(0xFFDDF3E6);
  static const Color progressTrack = Color(0xFFE5E7EB);
  static const Color sectionLabel = Color(0xFF9CA3AF);

  // Destructive
  static const Color danger = Color(0xFFDC2626);
}
