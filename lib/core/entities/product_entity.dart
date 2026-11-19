import 'package:fruit_hub_dash_board/core/entities/review_entity.dart';

/// A product exactly as the FruitHub client app reads it from Firestore.
class ProductEntity {
  final String id;
  final String name;
  final String nameEn;
  final String code;
  final String description;
  final String descriptionEn;
  final double price;
  final double? oldPrice;
  final String unit;
  final String unitEn;
  final String category;
  final String imageUrl;
  final bool isFeatured;
  final bool isOrganic;
  final int expirationMonths;
  final int numberOfCalories;
  final int quantity;
  final double avgRating;
  final int ratingCount;
  final int sellingCount;
  final List<ReviewEntity> reviews;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.code,
    required this.description,
    required this.descriptionEn,
    required this.price,
    this.oldPrice,
    this.unit = 'كيلو',
    this.unitEn = 'kg',
    required this.category,
    required this.imageUrl,
    required this.isFeatured,
    required this.isOrganic,
    required this.expirationMonths,
    required this.numberOfCalories,
    required this.quantity,
    this.avgRating = 0,
    this.ratingCount = 0,
    this.sellingCount = 0,
    this.reviews = const [],
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercent =>
      hasDiscount ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;

  bool get isLowStock => quantity <= 15;

  ProductEntity copyWith({
    String? id,
    String? imageUrl,
    bool? isFeatured,
    int? quantity,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name,
      nameEn: nameEn,
      code: code,
      description: description,
      descriptionEn: descriptionEn,
      price: price,
      oldPrice: oldPrice,
      unit: unit,
      unitEn: unitEn,
      category: category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isOrganic: isOrganic,
      expirationMonths: expirationMonths,
      numberOfCalories: numberOfCalories,
      quantity: quantity ?? this.quantity,
      avgRating: avgRating,
      ratingCount: ratingCount,
      sellingCount: sellingCount,
      reviews: reviews,
    );
  }
}
