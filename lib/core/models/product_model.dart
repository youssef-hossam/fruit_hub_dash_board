import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/entities/review_entity.dart';

/// Maps products to / from the Firestore documents used by the client app.
abstract class ProductModel {
  static ProductEntity fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      nameEn: (json['nameEn'] ?? json['name'] ?? '') as String,
      code: (json['code'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      descriptionEn:
          (json['descriptionEn'] ?? json['description'] ?? '') as String,
      price: (json['price'] as num? ?? 0).toDouble(),
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      unit: (json['unit'] ?? 'كيلو') as String,
      unitEn: (json['unitEn'] ?? 'kg') as String,
      category: (json['category'] ?? 'fruits') as String,
      imageUrl: (json['imageUrl'] ?? '') as String,
      isFeatured: (json['isFeatured'] ?? false) as bool,
      isOrganic: (json['isOrganic'] ?? false) as bool,
      expirationMonths: (json['expirationMonths'] as num? ?? 0).toInt(),
      numberOfCalories: (json['numberOfCalories'] as num? ?? 0).toInt(),
      quantity: (json['quantity'] as num? ?? 0).toInt(),
      avgRating: (json['avgRating'] as num? ?? 0).toDouble(),
      ratingCount: (json['ratingCount'] as num? ?? 0).toInt(),
      sellingCount: (json['sellingCount'] as num? ?? 0).toInt(),
      reviews: ((json['reviews'] as List?) ?? [])
          .map((e) => _reviewFromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  static Map<String, dynamic> toJson(ProductEntity p) {
    return {
      'id': p.id,
      'name': p.name,
      'nameEn': p.nameEn,
      'code': p.code,
      'description': p.description,
      'descriptionEn': p.descriptionEn,
      'price': p.price,
      // Written even when null, so removing a discount clears it in Firestore.
      'oldPrice': p.oldPrice,
      'unit': p.unit,
      'unitEn': p.unitEn,
      'category': p.category,
      'imageUrl': p.imageUrl,
      'isFeatured': p.isFeatured,
      'isOrganic': p.isOrganic,
      'expirationMonths': p.expirationMonths,
      'numberOfCalories': p.numberOfCalories,
      'quantity': p.quantity,
      'avgRating': p.avgRating,
      'ratingCount': p.ratingCount,
      'sellingCount': p.sellingCount,
      'reviews': p.reviews
          .map((r) => {
                'name': r.name,
                'image': r.image,
                'rating': r.rating,
                'date': r.date,
                'reviewDescription': r.reviewDescription,
              })
          .toList(),
    };
  }

  static ReviewEntity _reviewFromJson(Map<String, dynamic> json) {
    return ReviewEntity(
      name: (json['name'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      rating: (json['rating'] ?? 0) as num,
      date: (json['date'] ?? '') as String,
      reviewDescription: (json['reviewDescription'] ?? '') as String,
    );
  }
}
