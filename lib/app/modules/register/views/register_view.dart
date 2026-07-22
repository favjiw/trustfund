import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/phone_field.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
                title: 'Daftar',
                subtitle: 'Buat akun untuk melanjutkan',
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              AppTextField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                controller: controller.nameController,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: AppSpacing.lg.h),
              AppTextField(
                label: 'Email',
                hint: 'Masukkan email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSpacing.lg.h),
              AppTextField(
                label: 'Tanggal Lahir',
                hint: 'dd/mm/yyyy',
                controller: controller.birthDateController,
                readOnly: true,
                onTap: () => controller.pickBirthDate(context),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.iconMuted,
                  size: 20.sp,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              PhoneField(
                label: 'Nomor Telepon',
                hint: 'Masukkan nomor telepon',
                controller: controller.phoneController,
              ),
              SizedBox(height: AppSpacing.lg.h),
              PasswordField(
                label: 'Password',
                hint: 'Masukkan password',
                controller: controller.passwordController,
              ),
              SizedBox(height: AppSpacing.lg.h),
              PasswordField(
                label: 'Konfirmasi Password',
                hint: 'Masukkan ulang password',
                controller: controller.confirmPasswordController,
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              Obx(() => PrimaryButton(
                    label: 'Daftar',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  )),
              SizedBox(height: AppSpacing.xxl.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: AppTextStyles.c1Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Masuk',
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
