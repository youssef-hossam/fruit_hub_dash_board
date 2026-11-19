import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';

part 'products_state.dart';

/// Holds the catalogue for the whole dashboard (home stats, products tab,
/// product details) so every screen stays in sync after an edit.
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repo) : super(const ProductsLoading());

  final ProductRepo _repo;

  List<ProductEntity> get products =>
      state is ProductsLoaded ? (state as ProductsLoaded).products : const [];

  Future<void> load() async {
    emit(const ProductsLoading());
    final result = await _repo.getProducts();
    result.fold(
      (f) => emit(ProductsFailure(f.message)),
      (list) => emit(ProductsLoaded(list)),
    );
  }

  /// Called by the product form after a successful add / edit.
  void upsert(ProductEntity product) {
    final list = [...products];
    final i = list.indexWhere((p) => p.id == product.id);
    i == -1 ? list.insert(0, product) : list[i] = product;
    emit(ProductsLoaded(list));
  }

  /// Returns an error message, or null when it worked.
  Future<String?> delete(String id) async {
    final result = await _repo.deleteProduct(id);
    return result.fold((f) => f.message, (_) {
      emit(ProductsLoaded(products.where((p) => p.id != id).toList()));
      return null;
    });
  }

  /// Optimistic: flips the star right away and rolls back on failure.
  Future<String?> toggleFeatured(ProductEntity product) async {
    final updated = product.copyWith(isFeatured: !product.isFeatured);
    upsert(updated);
    final result = await _repo.setFeatured(product.id, updated.isFeatured);
    return result.fold((f) {
      upsert(product);
      return f.message;
    }, (_) => null);
  }
}
