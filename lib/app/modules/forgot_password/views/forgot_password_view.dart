import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
                title: 'Lupa Password',
                subtitle:
                    'Masukkan alamat email untuk menerima kode reset password',
                large: false,
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              AppTextField(
                label: 'Your Email',
                hint: 'Masukkan email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              PrimaryButton(
                label: 'Reset Password',
                gradient: false,
                onPressed: controller.resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
