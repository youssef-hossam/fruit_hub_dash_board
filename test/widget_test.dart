import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/models/order_model.dart';
import 'package:fruit_hub_dash_board/core/models/product_model.dart';
import 'package:fruit_hub_dash_board/core/demo/demo_data.dart';
import 'package:fruit_hub_dash_board/features/dash_board/domain/dashboard_stats.dart';

void main() {
  final now = DateTime(2026, 11, 19, 15);
  final products = demoProducts.map(ProductModel.fromJson).toList();
  final orders = demoOrders(now).map(OrderModel.fromJson).toList();

  test('product json round-trip keeps every field the client reads', () {
    final p = products.first;
    final back = ProductModel.fromJson(ProductModel.toJson(p));
    expect(back.name, p.name);
    expect(back.nameEn, p.nameEn);
    expect(back.oldPrice, p.oldPrice);
    expect(back.reviews.length, p.reviews.length);
    expect(back.quantity, p.quantity);
  });

  test('revenue ignores cancelled orders', () {
    final stats = DashboardStats.from(
      products: products,
      orders: orders,
      now: now,
    );
    final expected = orders
        .where((o) => o.status != OrderStatus.cancelled)
        .fold<double>(0, (s, o) => s + o.total);
    expect(stats.revenue, expected);
    expect(stats.ordersCount, orders.length);
    expect(stats.last7Days.length, 7);
    expect(stats.bestSellers.first.sellingCount,
        greaterThanOrEqualTo(stats.bestSellers.last.sellingCount));
  });

  test('order status flow', () {
    expect(OrderStatus.pending.next, OrderStatus.preparing);
    expect(OrderStatus.onTheWay.next, OrderStatus.delivered);
    expect(OrderStatus.delivered.next, isNull);
    expect(OrderStatus.cancelled.isOpen, isFalse);
  });

  test('discount percent', () {
    const p = ProductEntity(
      id: 'x',
      name: 'x',
      nameEn: 'x',
      code: 'x',
      description: '',
      descriptionEn: '',
      price: 75,
      oldPrice: 100,
      category: 'fruits',
      imageUrl: '',
      isFeatured: false,
      isOrganic: false,
      expirationMonths: 1,
      numberOfCalories: 1,
      quantity: 5,
    );
    expect(p.discountPercent, 25);
    expect(p.isLowStock, isTrue);
  });
}
