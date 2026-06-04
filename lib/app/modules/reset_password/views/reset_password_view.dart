import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

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
              const AppBackButton(),
              SizedBox(height: AppSpacing.xxl.h),
              const AuthHeader(
                title: 'Masukkan password baru',
                subtitle:
                    'Masukkan password baru, pastikan password tidak sama dengan yang lama',
                large: false,
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              PasswordField(
                label: 'Password',
                hint: 'Masukkan password baru',
                controller: controller.passwordController,
              ),
              SizedBox(height: AppSpacing.lg.h),
              PasswordField(
                label: 'Konfirmasi Password',
                hint: 'Masukkan ulang password baru',
                controller: controller.confirmPasswordController,
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              PrimaryButton(
                label: 'Update Password',
                gradient: false,
                onPressed: controller.updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
