import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.bodyLargeBold.copyWith(
              color: AppColors.grayscale950,
            ),
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              action!,
              style: AppStyles.bodySmallsemiBold.copyWith(
                color: AppColors.green1500,
              ),
            ),
          ),
      ],
    );
  }
}
