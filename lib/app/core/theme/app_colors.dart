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
}
