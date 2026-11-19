import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';

abstract class ProductRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Saves a new product. When [image] is given it is uploaded first and its
  /// URL is stored on the product.
  Future<Either<Failure, ProductEntity>> addProduct({
    required ProductEntity product,
    ({Uint8List bytes, String name})? image,
  });

  Future<Either<Failure, ProductEntity>> updateProduct({
    required ProductEntity product,
    ({Uint8List bytes, String name})? image,
  });

  Future<Either<Failure, void>> deleteProduct(String productId);

  Future<Either<Failure, void>> setFeatured(String productId, bool value);
}
