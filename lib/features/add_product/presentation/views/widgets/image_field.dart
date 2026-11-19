import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/app_network_image.dart';
import 'package:image_picker/image_picker.dart';

/// Picks a product photo. Works on mobile and web because it keeps the bytes
/// (not a dart:io File). Shows the current photo when editing.
class ImageField extends StatefulWidget {
  const ImageField({
    super.key,
    required this.onImageSelected,
    this.currentUrl = '',
  });

  final ValueChanged<({Uint8List bytes, String name})?> onImageSelected;
  final String currentUrl;

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  Uint8List? _bytes;

  Future<void> _pick() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file == null) return; // user closed the picker
    final bytes = await file.readAsBytes();
    setState(() => _bytes = bytes);
    widget.onImageSelected((bytes: bytes, name: file.name));
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _bytes != null || widget.currentUrl.isNotEmpty;
    return GestureDetector(
      onTap: _pick,
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.green150,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.green1200),
        ),
        child: Stack(
          children: [
            if (_bytes != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(_bytes!, fit: BoxFit.cover),
                ),
              )
            else if (widget.currentUrl.isNotEmpty)
              Positioned.fill(
                child: AppNetworkImage(url: widget.currentUrl, radius: 20),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: AppColors.green1500,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'اضغط لاختيار صورة المنتج',
                      style: AppStyles.bodySmallBold.copyWith(
                        color: AppColors.green1500,
                      ),
                    ),
                    Text(
                      'JPG أو PNG — يفضل خلفية فاتحة',
                      style: AppStyles.bodyXSmallRegular.copyWith(
                        color: AppColors.grayscale400,
                      ),
                    ),
                  ],
                ),
              ),
            if (hasImage)
              PositionedDirectional(
                bottom: 10,
                end: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.photo_camera_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'تغيير الصورة',
                        style: AppStyles.bodyXSmallBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
