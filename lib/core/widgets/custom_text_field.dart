import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.onSaved,
    this.maxLines = 1,
    this.controller,
    this.initialValue,
    this.isRequired = true,
    this.validator,
    this.textDirection,
  });

  final String hintText;
  final String? label;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final int maxLines;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return 'الحقل ده مطلوب';
        }
        return validator?.call(value);
      },
      onSaved: onSaved,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textDirection: textDirection,
      style: AppStyles.bodySmallsemiBold.copyWith(
        color: AppColors.grayscale950,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.bodySmallRegular.copyWith(
          color: AppColors.grayscale400,
        ),
        border: buildBorder(),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: AppColors.grayscale400, size: 20),
        filled: true,
        fillColor: const Color(0xffF9FAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: buildBorder(),
        focusedErrorBorder: buildBorder(const Color(0xffE45556)),
        errorBorder: buildBorder(const Color(0xffE45556)),
        focusedBorder: buildBorder(AppColors.green1500),
      ),
    );
    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: AppStyles.bodyXSmallBold.copyWith(
            color: AppColors.grayscale600,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  OutlineInputBorder buildBorder([Color color = const Color(0xffE6E9EA)]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color, width: 1.w),
    );
  }
}
