import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';

class IsFearturedCheckBox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  const IsFearturedCheckBox({super.key, required this.onChanged});

  @override
  State<IsFearturedCheckBox> createState() => _IsFearturedCheckBoxState();
}

class _IsFearturedCheckBoxState extends State<IsFearturedCheckBox> {
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      hoverColor: AppColors.green1500,
      activeColor: AppColors.green1500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      value: isFeatured,
      onChanged: (value) {
        setState(() {
          isFeatured = value ?? false;
        });
        widget.onChanged(isFeatured);
      },
    );
  }
}
