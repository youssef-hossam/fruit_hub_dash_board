import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/features/add_product/domain/entities/add_product_input_entity.dart';

abstract class ProductRepo {
  Future<Either<Failure, void>> addProduct({
    required AddProductInputEntity addProductInputEntity,
  });
}
