import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/repos/orders_repo/orders_repo.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repo) : super(const OrdersLoading());

  final OrdersRepo _repo;

  List<OrderEntity> get orders =>
      state is OrdersLoaded ? (state as OrdersLoaded).orders : const [];

  Future<void> load() async {
    emit(const OrdersLoading());
    final result = await _repo.getOrders();
    result.fold(
      (f) => emit(OrdersFailure(f.message)),
      (list) => emit(OrdersLoaded(list)),
    );
  }

  /// Moves an order to [status]; the client app reads the same field, so the
  /// customer sees the new step in "My orders". Returns an error or null.
  Future<String?> updateStatus(OrderEntity order, OrderStatus status) async {
    _replace(order.copyWith(status: status));
    final result = await _repo.updateStatus(orderId: order.id, status: status);
    return result.fold((f) {
      _replace(order);
      return f.message;
    }, (_) => null);
  }

  void _replace(OrderEntity order) {
    emit(OrdersLoaded([
      for (final o in orders) o.id == order.id ? order : o,
    ]));
  }
}
