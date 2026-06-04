import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/network_image_box.dart';
import '../../../widgets/profile_menu_section.dart';
import '../../../widgets/profile_menu_tile.dart';
import '../../../widgets/status_pill.dart';
import '../../../widgets/verified_badge.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl.w,
            AppSpacing.md.h,
            AppSpacing.xl.w,
            AppSpacing.xxl.h,
          ),
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.lg.h),
            _buildProfileCard(),
            SizedBox(height: AppSpacing.lg.h),
            _buildImpactCard(),
            SizedBox(height: AppSpacing.xl.h),
            _buildActivitySection(),
            SizedBox(height: AppSpacing.xl.h),
            _buildSecuritySection(),
            SizedBox(height: AppSpacing.xl.h),
            _buildOtherSection(),
            SizedBox(height: AppSpacing.xl.h),
            _buildLogoutButton(),
            SizedBox(height: AppSpacing.lg.h),
            Center(
              child: Text(
                controller.appVersion,
                style: AppTextStyles.c2Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Profil',
          style: AppTextStyles.h3Bold.copyWith(color: AppColors.textPrimary),
        ),
        const Spacer(),
        Icon(
          Icons.settings_outlined,
          size: 24.sp,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageBox(
            url: controller.avatarUrl,
            width: 56.w,
            height: 56.w,
            borderRadius: BorderRadius.circular(56.r),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h4Bold
                            .copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                    if (controller.verified) ...[
                      SizedBox(width: AppSpacing.sm.w),
                      const StatusPill.verified(),
                    ],
                  ],
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  controller.email,
                  style: AppTextStyles.c1Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Text(
              'Edit\nProfil',
              textAlign: TextAlign.right,
              style: AppTextStyles.c1Medium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        gradient: AppColors.darkCardGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dampak Kebaikanmu',
            style: AppTextStyles.c1Medium.copyWith(
              color: AppColors.onDarkCard,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _impactStat('Total Donasi', controller.totalDonationLabel),
                _impactDivider(),
                _impactStat('Kampanye Didukung', controller.supportedCount),
                _impactDivider(),
                _impactStat('Jiwa Terbantu', controller.livesHelped),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _impactStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.c2Regular
                .copyWith(color: AppColors.onDarkCardMuted),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            value,
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.onDarkCard),
          ),
        ],
      ),
    );
  }

  Widget _impactDivider() {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      color: AppColors.onDarkCardDivider,
    );
  }

  Widget _buildActivitySection() {
    return ProfileMenuSection(
      title: 'Aktivitas',
      tiles: [
        ProfileMenuTile(
          icon: Icons.history_rounded,
          label: 'Riwayat Donasi',
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.bookmark_border_rounded,
          label: 'Kampanye Tersimpan',
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.insert_chart_outlined_rounded,
          label: 'Laporan Dampak Saya',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return ProfileMenuSection(
      title: 'Akun & Keamanan',
      tiles: [
        ProfileMenuTile(
          icon: Icons.credit_card_rounded,
          label: 'Metode Pembayaran',
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.fingerprint_rounded,
          label: 'Verifikasi Identitas (KYC)',
          trailing: const StatusPill.done(),
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.lock_outline_rounded,
          label: 'Keamanan & Kata Sandi',
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.notifications_none_rounded,
          label: 'Notifikasi',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOtherSection() {
    return ProfileMenuSection(
      title: 'Lainnya',
      tiles: [
        ProfileMenuTile(
          icon: Icons.help_outline_rounded,
          label: 'Pusat Bantuan',
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.info_outline_rounded,
          label: 'Tentang TrustFund',
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.privacy_tip_outlined,
          label: 'Syarat & Kebijakan Privasi',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return Material(
      color: AppColors.white,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: controller.logout,
        child: Container(
          height: AppSpacing.buttonHeight.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.danger),
          ),
          child: Text(
            'Keluar',
            style: AppTextStyles.p2Medium.copyWith(
              color: AppColors.danger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
