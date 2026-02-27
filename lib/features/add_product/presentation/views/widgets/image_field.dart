import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageField extends StatefulWidget {
  final ValueChanged<File> onImageSelected;

  const ImageField({super.key, required this.onImageSelected});

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            await pickUpImage();
            if (imageFile != null) widget.onImageSelected(imageFile!);
            setState(() {});
          },
          child: Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),

            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageFile!,
                      height: 200.h,
                      // width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.image_outlined, size: 200.sp),
          ),
        ),

        if (imageFile != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imageFile = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 20.sp),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> pickUpImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.`
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
  }
}
