
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';

part 'add_product_state.dart';

/// Saves the product form: uploads the picked image (if any) and then adds a
/// new product or updates the existing one.
class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepo productRepo;

  AddProductCubit({required this.productRepo}) : super(AddProductInitial());

  Future<void> save({
    required ProductEntity product,
    required bool isEdit,
    ({Uint8List bytes, String name})? image,
  }) async {
    emit(AddProductLoading());
    final result = isEdit
        ? await productRepo.updateProduct(product: product, image: image)
        : await productRepo.addProduct(product: product, image: image);
    result.fold(
      (f) => emit(AddProductFailure(f.message)),
      (saved) => emit(AddProductSuccess(saved)),
    );
  }
}
