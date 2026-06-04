/// Spacing, radius and sizing scale (raw values).
///
/// Apply ScreenUtil at the call site, e.g. `SizedBox(height: AppSpacing.lg.h)`
/// or `BorderRadius.circular(AppSpacing.radiusMd.r)`.
class AppSpacing {
  AppSpacing._();

  // Spacing scale
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  // Corner radii
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;

  // Component sizes
  static const double fieldHeight = 56;
  static const double buttonHeight = 56;
  static const double otpBox = 58;
}
