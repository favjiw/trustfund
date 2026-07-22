import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/donation_qris_controller.dart';

class DonationQrisView extends GetView<DonationQrisController> {
  const DonationQrisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSummary(),
            Expanded(
              child: Obx(() {
                switch (controller.phase.value) {
                  case QrisPhase.expired:
                    return _buildResult(
                      icon: Icons.timer_off_outlined,
                      color: AppColors.danger,
                      title: 'Waktu pembayaran habis',
                      body: 'QRIS telah kedaluwarsa. Silakan ulangi donasi '
                          'untuk membuat kode pembayaran baru.',
                    );
                  case QrisPhase.failed:
                    return _buildResult(
                      icon: Icons.error_outline_rounded,
                      color: AppColors.danger,
                      title: 'Pembayaran gagal',
                      body: 'Pembayaran tidak berhasil diproses. Silakan '
                          'coba lagi.',
                    );
                  case QrisPhase.error:
                    return _buildResult(
                      icon: Icons.wifi_off_rounded,
                      color: AppColors.danger,
                      title: 'Terjadi kesalahan',
                      body: controller.errorMessage.value.isEmpty
                          ? 'Tidak dapat memuat halaman pembayaran.'
                          : controller.errorMessage.value,
                    );
                  case QrisPhase.waiting:
                  case QrisPhase.paid:
                    return WebViewWidget(
                      controller: controller.webViewController,
                    );
                }
              }),
            ),
            _buildFooter(),
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
              'Pembayaran QRIS',
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.summaryBoxBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.args.campaignTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Total ${controller.formattedAmount}',
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildResult({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.sp, color: color),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTextStyles.p2Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
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
        child: Obx(() {
          switch (controller.phase.value) {
            case QrisPhase.waiting:
            case QrisPhase.paid:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          'Menunggu pembayaran… Pindai QRIS di atas dengan '
                          'aplikasi e-wallet, atau tekan tombol untuk membayar.',
                          style: AppTextStyles.c2Regular
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  PrimaryButton(
                    label: 'Bayar ${controller.formattedAmount}',
                    isLoading: controller.isPaying.value,
                    onPressed: controller.payNow,
                  ),
                ],
              );
            case QrisPhase.expired:
            case QrisPhase.failed:
            case QrisPhase.error:
              return PrimaryButton(
                label: 'Kembali',
                onPressed: Get.back,
              );
          }
        }),
      ),
    );
  }
}
