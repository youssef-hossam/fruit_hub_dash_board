import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/core/models/order_model.dart';
import 'package:fruit_hub_dash_board/core/repos/orders_repo/orders_repo.dart';
import 'package:fruit_hub_dash_board/core/services/database_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';

class OrdersRepoImpl implements OrdersRepo {
  final DatabaseService databaseService;

  OrdersRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final docs = await databaseService.getCollection(
        path: BackEndEndpoints.orders,
      );
      final orders = docs.map(OrderModel.fromJson).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return right(orders);
    } catch (e) {
      return left(ServerFailure('تعذر تحميل الطلبات: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await databaseService.updateData(
        path: BackEndEndpoints.orders,
        documentId: orderId,
        data: {'status': status.name},
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure('تعذر تحديث حالة الطلب: $e'));
    }
  }
}
