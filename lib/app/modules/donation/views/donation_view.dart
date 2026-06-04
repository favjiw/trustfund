import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/campaign_mini_card.dart';
import '../../../widgets/info_banner.dart';
import '../../../widgets/nominal_option_card.dart';
import '../../../widgets/payment_method_tile.dart';
import '../controllers/donation_controller.dart';

class DonationView extends GetView<DonationController> {
  const DonationView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  CampaignMiniCard(
                    imageUrl: controller.campaignImageUrl,
                    title: controller.campaignTitle,
                    organizer: controller.campaignOrganizer,
                    verified: controller.campaignVerified,
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  _sectionTitle('Pilih Nominal Donasi'),
                  SizedBox(height: AppSpacing.md.h),
                  _buildNominalGrid(),
                  SizedBox(height: AppSpacing.md.h),
                  _buildCustomAmountField(),
                  SizedBox(height: AppSpacing.xl.h),
                  _sectionTitle('Metode Pembayaran'),
                  SizedBox(height: AppSpacing.md.h),
                  _buildPaymentMethods(),
                  SizedBox(height: AppSpacing.xl.h),
                  _buildMessageField(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildHideNameRow(),
                  SizedBox(height: AppSpacing.lg.h),
                  const InfoBanner(
                    icon: Icons.lock_outline_rounded,
                    body: 'Dana dikunci Smart Contract — cair bertahap setelah '
                        'tervalidasi AI untuk memastikan transparansi '
                        'penggunaan dana donasi Anda.',
                  ),
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
              'Donasi',
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Icon(
            Icons.account_circle_outlined,
            size: 24.sp,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildNominalGrid() {
    return Obx(() {
      final rows = <Widget>[];
      for (var i = 0; i < controller.nominals.length; i += 2) {
        rows.add(
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: Row(
              children: [
                Expanded(child: _nominalCard(i)),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: i + 1 < controller.nominals.length
                      ? _nominalCard(i + 1)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }
      return Column(children: rows);
    });
  }

  Widget _nominalCard(int index) {
    final option = controller.nominals[index];
    return NominalOptionCard(
      label: option.label,
      value: option.value,
      selected: controller.selectedNominal.value == index,
      onTap: () => controller.onNominalSelected(index),
    );
  }

  Widget _buildCustomAmountField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            'Rp',
            style: AppTextStyles.p2Medium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: TextField(
              controller: controller.customAmountController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.p2Regular
                  .copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Nominal Lainnya',
                hintStyle:
                    AppTextStyles.p2Regular.copyWith(color: AppColors.hint),
                contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Obx(
      () => Column(
        children: List.generate(controller.paymentMethods.length, (index) {
          final method = controller.paymentMethods[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == controller.paymentMethods.length - 1
                  ? 0
                  : AppSpacing.md.h,
            ),
            child: PaymentMethodTile(
              icon: method.icon,
              label: method.label,
              selected: controller.selectedPayment.value == index,
              onTap: () => controller.onPaymentSelected(index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tulis pesan untuk yayasan (Opsional)',
          style: AppTextStyles.c1Medium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.sm.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller.messageController,
            maxLines: 3,
            style:
                AppTextStyles.p2Regular.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Semoga bermanfaat untuk pendidikan adik-adik...',
              hintStyle:
                  AppTextStyles.p2Regular.copyWith(color: AppColors.hint),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHideNameRow() {
    return Row(
      children: [
        Icon(
          Icons.visibility_off_outlined,
          size: 22.sp,
          color: AppColors.label,
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sembunyikan nama saya',
                style: AppTextStyles.p2Regular.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Donasi sebagai Anonim',
                style: AppTextStyles.c2Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Obx(
          () => Switch.adaptive(
            value: controller.hideName.value,
            activeColor: AppColors.primary,
            onChanged: controller.toggleHideName,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOTAL DONASI',
                  style: AppTextStyles.c2Medium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Obx(
                  () => Text(
                    controller.formattedTotal,
                    style: AppTextStyles.h4Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            SizedBox(width: AppSpacing.lg.w),
            Expanded(
              child: SizedBox(
                height: AppSpacing.buttonHeight.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: radius,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: radius,
                      onTap: controller.submitDonation,
                      child: Center(
                        child: Obx(
                          () => Text(
                            'Donasi ${controller.formattedTotal}',
                            style: AppTextStyles.p2Medium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
