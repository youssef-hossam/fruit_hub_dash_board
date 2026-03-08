import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_button.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_text_field.dart';
import 'package:fruit_hub_dash_board/features/add_product/domain/entities/add_product_input_entity.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/manger/add_product_cubit/add_product_cubit.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/image_field.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/is_feartured_check_box.dart';

class AddProductViewBody extends StatefulWidget {
  const AddProductViewBody({super.key});

  @override
  State<AddProductViewBody> createState() => _AddProductViewBodyState();
}

class _AddProductViewBodyState extends State<AddProductViewBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;
  late double price;
  late String description;
  late int quantity;
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
              CustomTextField(
                hintText: ' Name',
                onSaved: (value) => name = value!,
              ),
              SizedBox(height: 20),

              CustomTextField(
                hintText: ' Price',
                onSaved: (value) => price = double.parse(value!),
              ),
              SizedBox(height: 20),

              CustomTextField(
                hintText: ' Quantity',
                onSaved: (value) => quantity = int.parse(value!),
              ),
              SizedBox(height: 20),

              CustomTextField(
                hintText: ' Description',
                maxLines: 5,
                onSaved: (value) => description = value!,
              ),
              Row(
                children: [
                  Text('Is Featured'),
                  IsFearturedCheckBox(
                    onChanged: (value) {
                      isFeatured = value;
                    },
                  ),
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
                    context.read<AddProductCubit>().addProduct(
                      AddProductInputEntity(
                        name: name,
                        description: description,
                        price: price,
                        quantity: quantity,
                        isFeatured: isFeatured,
                        image: image!,
                      ),
                    );
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
