import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_text_field.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/image_field.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/widgets/is_feartured_check_box.dart';

class AddProductView extends StatefulWidget {
  static const String routeName = 'add_product';
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: autovalidateMode,
            key: formKey,

            child: Column(
              children: [
                CustomTextField(hintText: ' Name'),
                SizedBox(height: 20),

                CustomTextField(hintText: ' Price'),
                SizedBox(height: 20),

                CustomTextField(hintText: ' Description', maxLines: 5),
                Row(
                  children: [
                    Text('Is Featured'),
                    IsFearturedCheckBox(onChanged: (value) => print(value)),
                  ],
                ),
                SizedBox(height: 20),
                ImageField(
                  onImageSelected: (File image) {
                    // Handle the selected image file
                    print('Selected image path: ${image.path}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
