import 'package:get/get.dart';

import '../modules/botnavbar/bindings/botnavbar_binding.dart';
import '../modules/botnavbar/views/botnavbar_view.dart';
import '../modules/campaign/bindings/campaign_binding.dart';
import '../modules/campaign/views/campaign_view.dart';
import '../modules/campaign_detail/bindings/campaign_detail_binding.dart';
import '../modules/campaign_detail/views/campaign_detail_view.dart';
import '../modules/donation/bindings/donation_binding.dart';
import '../modules/donation/views/donation_view.dart';
import '../modules/donation_success/bindings/donation_success_binding.dart';
import '../modules/donation_success/views/donation_success_view.dart';
import '../modules/payment_instruction/bindings/payment_instruction_binding.dart';
import '../modules/payment_instruction/views/payment_instruction_view.dart';
import '../modules/track_donation/bindings/track_donation_binding.dart';
import '../modules/track_donation/views/track_donation_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CAMPAIGN_DETAIL;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.BOTNAVBAR,
      page: () => const BotNavBarView(),
      binding: BotNavBarBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CAMPAIGN,
      page: () => const CampaignView(),
      binding: CampaignBinding(),
    ),
    GetPage(
      name: _Paths.CAMPAIGN_DETAIL,
      page: () => const CampaignDetailView(),
      binding: CampaignDetailBinding(),
    ),
    GetPage(
      name: _Paths.DONATION,
      page: () => const DonationView(),
      binding: DonationBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_INSTRUCTION,
      page: () => const PaymentInstructionView(),
      binding: PaymentInstructionBinding(),
    ),
    GetPage(
      name: _Paths.DONATION_SUCCESS,
      page: () => const DonationSuccessView(),
      binding: DonationSuccessBinding(),
    ),
    GetPage(
      name: _Paths.TRACK_DONATION,
      page: () => const TrackDonationView(),
      binding: TrackDonationBinding(),
    ),
    GetPage(
      name: _Paths.SAVED,
      page: () => const SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
