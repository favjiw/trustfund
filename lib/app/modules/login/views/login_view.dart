import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/google_logo.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/social_button.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl.w,
            vertical: AppSpacing.lg.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.huge.h),
              const AuthHeader(
                title: 'Masuk',
                subtitle: 'Masukkan alamat email dan kata sandi',
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              AppTextField(
                label: 'Email',
                hint: 'Masukkan email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSpacing.lg.h),
              PasswordField(
                label: 'Password',
                hint: 'Masukkan password',
                controller: controller.passwordController,
              ),
              SizedBox(height: AppSpacing.md.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.goToForgotPassword,
                  child: Text(
                    'Lupa password?',
                    style: AppTextStyles.c1Medium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              Obx(() => PrimaryButton(
                    label: 'Masuk',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  )),
              SizedBox(height: AppSpacing.xl.h),
              const _OrDivider(),
              SizedBox(height: AppSpacing.xl.h),
              SocialButton(
                icon: const GoogleLogo(),
                label: 'Masuk dengan Google',
                onPressed: () => AppDialogs.comingSoon('Masuk dengan Google'),
              ),
              SizedBox(height: AppSpacing.md.h),
              SocialButton(
                icon: Icon(
                  Icons.facebook,
                  color: AppColors.facebook,
                  size: 24.sp,
                ),
                label: 'Masuk dengan Facebook',
                onPressed: () => AppDialogs.comingSoon('Masuk dengan Facebook'),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: AppTextStyles.c1Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: Text(
                        'Daftar',
                        style: AppTextStyles.c1Medium
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Text(
            'Atau',
            style: AppTextStyles.c1Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}
