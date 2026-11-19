part of 'orders_cubit.dart';

sealed class OrdersState {
  const OrdersState();
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

final class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  const OrdersLoaded(this.orders);
}

final class OrdersFailure extends OrdersState {
  final String message;
  const OrdersFailure(this.message);
}
