part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const OTP_VERIFICATION = _Paths.OTP_VERIFICATION;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const HOME = _Paths.HOME;
  static const BOTNAVBAR = _Paths.BOTNAVBAR;
  static const CAMPAIGN = _Paths.CAMPAIGN;
  static const CAMPAIGN_DETAIL = _Paths.CAMPAIGN_DETAIL;
  static const DONATION = _Paths.DONATION;
  static const PAYMENT_INSTRUCTION = _Paths.PAYMENT_INSTRUCTION;
  static const DONATION_SUCCESS = _Paths.DONATION_SUCCESS;
  static const TRACK_DONATION = _Paths.TRACK_DONATION;
  static const SAVED = _Paths.SAVED;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP_VERIFICATION = '/otp-verification';
  static const RESET_PASSWORD = '/reset-password';
  static const HOME = '/home';
  static const BOTNAVBAR = '/botnavbar';
  static const CAMPAIGN = '/campaign';
  static const CAMPAIGN_DETAIL = '/campaign-detail';
  static const DONATION = '/donation';
  static const PAYMENT_INSTRUCTION = '/payment-instruction';
  static const DONATION_SUCCESS = '/donation-success';
  static const TRACK_DONATION = '/track-donation';
  static const SAVED = '/saved';
  static const PROFILE = '/profile';
}
