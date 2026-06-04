import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/otp_input.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

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
                title: 'Cek email',
                subtitle:
                    'Kami telah mengirimkan kode verifikasi ke dale@gmail.com',
                large: false,
              ),
              SizedBox(height: AppSpacing.md.h),
              Text(
                'Masukkan kode 5 digit yang tercantum dalam email',
                style: AppTextStyles.c1Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              OtpInput(
                length: 5,
                onChanged: controller.onCodeChanged,
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              PrimaryButton(
                label: 'Verifikasi Kode',
                gradient: false,
                onPressed: controller.verify,
              ),
              SizedBox(height: AppSpacing.xxl.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum dapat email? ',
                      style: AppTextStyles.c1Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: controller.resend,
                      child: Text(
                        'Kirim ulang',
                        style: AppTextStyles.c1Medium.copyWith(
                          color: AppColors.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
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
