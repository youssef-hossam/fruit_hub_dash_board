import 'package:flutter/material.dart';

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
