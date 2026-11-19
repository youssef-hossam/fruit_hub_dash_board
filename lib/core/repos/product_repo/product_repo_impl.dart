import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/core/models/product_model.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/core/services/database_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';

class ProductRepoImpl implements ProductRepo {
  final DatabaseService databaseService;
  final ImageRepo imageRepo;

  ProductRepoImpl({required this.databaseService, required this.imageRepo});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final docs = await databaseService.getCollection(
        path: BackEndEndpoints.products,
      );
      final products = docs.map(ProductModel.fromJson).toList()
        ..sort((a, b) => b.sellingCount.compareTo(a.sellingCount));
      return right(products);
    } catch (e) {
      return left(ServerFailure('تعذر تحميل المنتجات: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct({
    required ProductEntity product,
    ({Uint8List bytes, String name})? image,
  }) async {
    final withImage = await _attachImage(product, image);
    return withImage.fold(left, (p) async {
      try {
        // Same id as the document, so the client app can always find it.
        final id = p.id.isNotEmpty
            ? p.id
            : 'p_${DateTime.now().millisecondsSinceEpoch}';
        final saved = p.copyWith(id: id);
        await databaseService.addData(
          path: BackEndEndpoints.products,
          documentId: id,
          data: ProductModel.toJson(saved),
        );
        return right(saved);
      } catch (e) {
        return left(ServerFailure('تعذر إضافة المنتج: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct({
    required ProductEntity product,
    ({Uint8List bytes, String name})? image,
  }) async {
    final withImage = await _attachImage(product, image);
    return withImage.fold(left, (p) async {
      try {
        await databaseService.updateData(
          path: BackEndEndpoints.products,
          documentId: p.id,
          data: ProductModel.toJson(p),
        );
        return right(p);
      } catch (e) {
        return left(ServerFailure('تعذر حفظ التعديلات: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await databaseService.deleteData(
        path: BackEndEndpoints.products,
        documentId: productId,
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure('تعذر حذف المنتج: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setFeatured(String productId, bool value) async {
    try {
      await databaseService.updateData(
        path: BackEndEndpoints.products,
        documentId: productId,
        data: {'isFeatured': value},
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure('تعذر تحديث المنتج: $e'));
    }
  }

  Future<Either<Failure, ProductEntity>> _attachImage(
    ProductEntity product,
    ({Uint8List bytes, String name})? image,
  ) async {
    if (image == null) return right(product);
    final result = await imageRepo.uploadImage(
      bytes: image.bytes,
      fileName: image.name,
    );
    return result.map((url) => product.copyWith(imageUrl: url));
  }
}
