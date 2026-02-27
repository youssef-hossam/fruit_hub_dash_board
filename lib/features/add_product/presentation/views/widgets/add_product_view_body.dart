import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_button.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_text_field.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/image_field.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/is_feartured_check_box.dart';
import 'dart:io';

class AddProductViewBody extends StatefulWidget {
  const AddProductViewBody({super.key});

  @override
  State<AddProductViewBody> createState() => _AddProductViewBodyState();
}

class _AddProductViewBodyState extends State<AddProductViewBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;
  late String price;
  late String description;
  late bool isFeatured;
  File? image;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  this.image = image;
                  setState(() {});
                },
              ),

              SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  if (image == null || image!.path.isEmpty) {
                    return ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an image')),
                    );
                  } else if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    // Proceed with adding the product using the collected data
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                  }
                },
                text: 'Add Product',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
