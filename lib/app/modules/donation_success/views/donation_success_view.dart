import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../widgets/copy_field.dart';
import '../../../widgets/detail_row.dart';
import '../../../widgets/donor_network_graph.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/skeleton_box.dart';
import '../../../widgets/status_pill.dart';
import '../../../widgets/verified_badge.dart';
import '../controllers/donation_success_controller.dart';

class DonationSuccessView extends GetView<DonationSuccessController> {
  const DonationSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final receipt = controller.receipt;
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl.w,
                  AppSpacing.xxl.h,
                  AppSpacing.xl.w,
                  AppSpacing.xxl.h,
                ),
                children: [
                  _buildHeader(),
                  SizedBox(height: AppSpacing.xl.h),
                  _buildAmountCard(receipt),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildOnChainCard(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildDonorNetworkCard(),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildNote(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 88.w,
          height: 88.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.verifiedFundBg,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 60.w,
            height: 60.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
            child: Icon(Icons.check_rounded, size: 34.sp, color: AppColors.white),
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          'Donasi Berhasil!',
          style: AppTextStyles.h3Bold.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          'Terima kasih, donasi Anda telah dikunci di Smart Contract dan '
          'tercatat permanen di blockchain.',
          textAlign: TextAlign.center,
          style: AppTextStyles.c1Regular.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard(DonationReceipt receipt) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'NOMINAL DONASI',
            style: AppTextStyles.c2Medium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            receipt.formattedAmount,
            style: AppTextStyles.h2Bold.copyWith(color: AppColors.primary),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          DetailRow(label: 'Kampanye', value: receipt.campaignTitle),
          DetailRow(
            label: 'Yayasan',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    receipt.organizer,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.c1Medium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (receipt.verified) ...[
                  SizedBox(width: AppSpacing.xs.w),
                  const VerifiedBadge(size: 14),
                ],
              ],
            ),
          ),
          DetailRow(label: 'Tanggal', value: receipt.dateLabel),
          DetailRow(
            label: 'Status',
            trailing: const StatusPill(
              label: 'Dana Terkunci di Escrow',
              icon: Icons.lock_outline_rounded,
              background: AppColors.successBg,
              foreground: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnChainCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link_rounded, size: 18.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                'Bukti On-Chain',
                style: AppTextStyles.p2Medium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Obx(() {
            // Deposit not yet confirmed on chain (e.g. status still PAID).
            if (!controller.hasProof) {
              // Polling gave up — offer a manual re-check.
              if (controller.proofUnavailable.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pembayaran diterima. Bukti on-chain belum tersedia — '
                      'transaksi masih diproses di blockchain. Coba muat ulang '
                      'beberapa saat lagi.',
                      style: AppTextStyles.c2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: controller.refreshProof,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh_rounded,
                              size: 16.sp, color: AppColors.primary),
                          SizedBox(width: AppSpacing.xs.w),
                          Text(
                            'Muat Ulang',
                            style: AppTextStyles.c1Medium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Text(
                      'Pembayaran diterima. Menunggu konfirmasi transaksi '
                      'di blockchain…',
                      style: AppTextStyles.c2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CopyField(
                  label: 'TRANSACTION HASH',
                  value: controller.displayHash,
                  onCopy: controller.copyTransactionHash,
                ),
                SizedBox(height: AppSpacing.md.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.openExplorer,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd.r),
                      ),
                    ),
                    icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                    label: Text(
                      'Lihat di Blockchain Explorer',
                      style: AppTextStyles.c1Medium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// "Jaringan Donatur" card: shows where the user's contribution sits among
  /// the campaign's other donors. Best-effort — hidden when the campaign id
  /// is unknown, with a quiet retry when loading fails.
  Widget _buildDonorNetworkCard() {
    return Obx(() {
      final graph = controller.donorGraph.value;
      final isLoading = controller.isGraphLoading.value;
      final hasError = controller.graphError.value;
      if (graph == null && !isLoading && !hasError) {
        return const SizedBox.shrink();
      }

      Widget content;
      if (graph != null) {
        content = DonorNetworkGraph(graph: graph);
      } else if (isLoading) {
        content = SkeletonBox(
          height: 280.h,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        );
      } else {
        content = Row(
          children: [
            Expanded(
              child: Text(
                'Gagal memuat jaringan donatur.',
                style: AppTextStyles.c2Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: controller.loadDonorGraph,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded,
                      size: 16.sp, color: AppColors.primary),
                  SizedBox(width: AppSpacing.xs.w),
                  Text(
                    'Muat Ulang',
                    style: AppTextStyles.c1Medium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

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
                Icon(Icons.hub_outlined, size: 18.sp, color: AppColors.primary),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  'Jaringan Donatur',
                  style: AppTextStyles.p2Medium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'Kontribusimu kini menjadi bagian dari jaringan kebaikan ini.',
              style: AppTextStyles.c2Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.md.h),
            content,
          ],
        ),
      );
    });
  }

  Widget _buildNote() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.eco_outlined, size: 18.sp, color: AppColors.success),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              'Dana akan cair bertahap ke yayasan hanya setelah bukti '
              'penggunaan divalidasi AI.',
              style: AppTextStyles.c2Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
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
              label: 'Lacak Donasi Saya',
              gradient: false,
              onPressed: controller.trackDonation,
            ),
            SizedBox(height: AppSpacing.sm.h),
            TextButton(
              onPressed: controller.backToHome,
              child: Text(
                'Kembali ke Beranda',
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
