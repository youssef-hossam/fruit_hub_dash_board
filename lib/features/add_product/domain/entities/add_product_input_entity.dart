import 'dart:io';

class AddProductInputEntity {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final bool isFeatured;
  final File image;
  final String imagePath;

  AddProductInputEntity({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.isFeatured,
    required this.image,
    required this.imagePath,
  });
}
