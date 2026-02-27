import 'package:fruit_hub_dash_board/features/add_product/domain/entities/add_product_input_entity.dart';

abstract class ProductRepo {
  Future<void> addProduct({
    required AddProductInputEntity addProductInputEntity,
  });
}
