import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'primary_button.dart';

/// Centered feedback block used for error and empty states across the app.
///
/// Use [StateMessage.error] to show a friendly failure message with a retry
/// action, or [StateMessage.empty] when there is simply no content to display.
class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  /// Failure state with a "Coba Lagi" (Try again) button wired to [onRetry].
  const StateMessage.error({super.key, VoidCallback? onRetry})
      : icon = Icons.cloud_off_rounded,
        title = 'Gagal memuat kampanye',
        message = 'Terjadi kesalahan saat memuat data. Periksa koneksi '
            'internet Anda lalu coba lagi.',
        actionLabel = 'Coba Lagi',
        onAction = onRetry;

  /// Empty state shown when there are no campaigns to display.
  const StateMessage.empty({super.key})
      : icon = Icons.inbox_outlined,
        title = 'Belum ada kampanye',
        message = 'Kampanye akan muncul di sini begitu tersedia.',
        actionLabel = null,
        onAction = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl.w,
          vertical: AppSpacing.xxl.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: const BoxDecoration(
                color: AppColors.summaryBoxBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.c1Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg.h),
              SizedBox(
                width: 160.w,
                child: PrimaryButton(
                  label: actionLabel!,
                  onPressed: onAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
