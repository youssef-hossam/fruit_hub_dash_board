import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';

abstract class OrdersRepo {
  /// All customer orders, newest first.
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  Future<Either<Failure, void>> updateStatus({
    required String orderId,
    required OrderStatus status,
  });
}
