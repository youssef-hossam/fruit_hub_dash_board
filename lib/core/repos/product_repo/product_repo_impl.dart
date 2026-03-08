import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/core/services/database_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';
import 'package:fruit_hub_dash_board/features/add_product/data/models/add_product_input_model.dart';
import 'package:fruit_hub_dash_board/features/add_product/domain/entities/add_product_input_entity.dart';

class ProductRepoImpl implements ProductRepo {
  final DatabaseService databaseService;

  ProductRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, void>> addProduct({
    required AddProductInputEntity addProductInputEntity,
  }) async {
    try {
      await databaseService.addData(
        path: BackEndEndpoints.addProduct,
        data: AddProductInputModel.fromEntity(addProductInputEntity).toJson(),
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure('Failed to add product: ${e.toString()}'));
    }
  }
}
