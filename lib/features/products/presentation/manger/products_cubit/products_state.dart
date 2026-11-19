part of 'products_cubit.dart';

sealed class ProductsState {
  const ProductsState();
}

final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

final class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  const ProductsLoaded(this.products);
}

final class ProductsFailure extends ProductsState {
  final String message;
  const ProductsFailure(this.message);
}
