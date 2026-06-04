import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'app_input_decoration.dart';
import 'field_label.dart';

/// A labeled phone field with a fixed dial-code prefix box.
class PhoneField extends StatelessWidget {
  final String label;
  final String dialCode;
  final String? hint;
  final TextEditingController? controller;

  const PhoneField({
    super.key,
    required this.label,
    this.dialCode = '+62',
    this.hint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        Row(
          children: [
            Container(
              height: AppSpacing.fieldHeight.h,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                dialCode,
                style: AppTextStyles.p2Regular
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.p2Regular
                    .copyWith(color: AppColors.textPrimary),
                decoration: appInputDecoration(hint: hint),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
