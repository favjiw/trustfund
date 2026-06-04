import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/copy_field.dart';
import '../../../widgets/info_banner.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/payment_instruction_controller.dart';

class PaymentInstructionView extends GetView<PaymentInstructionController> {
  const PaymentInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    final receipt = controller.receipt;
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl.w,
                  AppSpacing.md.h,
                  AppSpacing.xl.w,
                  AppSpacing.xxl.h,
                ),
                children: [
                  _buildCountdown(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildTotalCard(receipt.formattedAmount, receipt.campaignTitle),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildVaCard(receipt.paymentLabel, receipt.vaNumber),
                  SizedBox(height: AppSpacing.lg.h),
                  const InfoBanner(
                    icon: Icons.shield_outlined,
                    body: 'Dana Anda akan langsung dikunci di Smart Contract '
                        'setelah pembayaran terverifikasi, dan hanya cair '
                        'bertahap setelah divalidasi AI.',
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildStepsCard(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        children: [
          const AppBackButton(),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              'Secure Payment',
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildCountdown() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Column(
        children: [
          Text(
            'Selesaikan pembayaran dalam',
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Obx(
            () => Text(
              controller.formattedCountdown,
              style: AppTextStyles.h3Bold.copyWith(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(String amount, String campaignTitle) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'Total Donasi',
            style: AppTextStyles.c1Regular
                .copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            amount,
            style: AppTextStyles.h2Bold.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            campaignTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.c1Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildVaCard(String paymentLabel, String vaNumber) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
                ),
                child: Text(
                  'BCA',
                  style: AppTextStyles.c2Medium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                paymentLabel,
                style: AppTextStyles.p2Medium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          CopyField(
            label: 'Nomor Virtual Account',
            value: vaNumber,
            actionLabel: 'Salin',
            background: AppColors.summaryBoxBg,
            onCopy: controller.copyVaNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: controller.toggleSteps,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Cara Pembayaran',
                    style: AppTextStyles.h4Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Obx(
                  () => Icon(
                    controller.stepsExpanded.value
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 24.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.stepsExpanded.value
                ? Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md.h),
                    child: Column(
                      children: List.generate(controller.steps.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: _buildStep(index + 1, controller.steps[index]),
                        );
                      }),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.summaryBoxBg,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: AppTextStyles.c2Medium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs.h),
            child: Text(
              text,
              style: AppTextStyles.c1Regular
                  .copyWith(color: AppColors.textPrimary, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        AppSpacing.md.h,
        AppSpacing.xl.w,
        AppSpacing.lg.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: 'Saya Sudah Bayar',
              onPressed: controller.confirmPayment,
            ),
            SizedBox(height: AppSpacing.sm.h),
            TextButton(
              onPressed: controller.cancelDonation,
              child: Text(
                'Batalkan Donasi',
                style: AppTextStyles.c1Medium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
