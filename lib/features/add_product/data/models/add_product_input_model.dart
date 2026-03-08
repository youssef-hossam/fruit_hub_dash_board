import 'dart:io';

import 'package:fruit_hub_dash_board/features/add_product/domain/entities/add_product_input_entity.dart';

class AddProductInputModel {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final bool isFeatured;
  final File image;
  String imageUrl;

  AddProductInputModel({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.isFeatured,
    required this.image,
    this.imageUrl = '',
  });

  factory AddProductInputModel.fromEntity(
    AddProductInputEntity addProductInputEntity,
  ) {
    return AddProductInputModel(
      name: addProductInputEntity.name,
      description: addProductInputEntity.description,
      price: addProductInputEntity.price,
      quantity: addProductInputEntity.quantity,
      isFeatured: addProductInputEntity.isFeatured,
      image: addProductInputEntity.image,
      imageUrl: addProductInputEntity.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'isFeatured': isFeatured,
      'imageUrl': imageUrl,
    };
  }
}
