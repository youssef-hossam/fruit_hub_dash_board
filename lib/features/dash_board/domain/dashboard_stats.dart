import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';

/// Everything the home screen shows, worked out from products + orders.
/// Kept as plain Dart so it is easy to unit-test.
class DashboardStats {
  final double revenue;
  final int ordersCount;
  final int openOrders;
  final int customers;
  final int productsCount;
  final double avgRating;
  final double avgOrderValue;

  /// Revenue for each of the last 7 days, oldest first.
  final List<({DateTime day, double total})> last7Days;
  final Map<OrderStatus, int> byStatus;
  final List<ProductEntity> bestSellers;
  final List<ProductEntity> lowStock;
  final List<OrderEntity> recentOrders;

  const DashboardStats({
    required this.revenue,
    required this.ordersCount,
    required this.openOrders,
    required this.customers,
    required this.productsCount,
    required this.avgRating,
    required this.avgOrderValue,
    required this.last7Days,
    required this.byStatus,
    required this.bestSellers,
    required this.lowStock,
    required this.recentOrders,
  });

  factory DashboardStats.from({
    required List<ProductEntity> products,
    required List<OrderEntity> orders,
    DateTime? now,
  }) {
    final today = _dayOf(now ?? DateTime.now());
    // Cancelled orders never count as income.
    final paid = orders.where((o) => o.status != OrderStatus.cancelled);
    final revenue = paid.fold<double>(0, (s, o) => s + o.total);

    final days = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final total = paid
          .where((o) => _dayOf(o.createdAt) == day)
          .fold<double>(0, (s, o) => s + o.total);
      return (day: day, total: total);
    });

    final rated = products.where((p) => p.ratingCount > 0).toList();
    final sorted = [...products]
      ..sort((a, b) => b.sellingCount.compareTo(a.sellingCount));
    final recent = [...orders]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DashboardStats(
      revenue: revenue,
      ordersCount: orders.length,
      openOrders: orders.where((o) => o.status.isOpen).length,
      customers: orders.map((o) => o.uid).toSet().length,
      productsCount: products.length,
      avgRating: rated.isEmpty
          ? 0
          : rated.fold<double>(0, (s, p) => s + p.avgRating) / rated.length,
      avgOrderValue: paid.isEmpty ? 0 : revenue / paid.length,
      last7Days: days,
      byStatus: {
        for (final s in OrderStatus.values)
          s: orders.where((o) => o.status == s).length,
      },
      bestSellers: sorted.take(5).toList(),
      lowStock: products.where((p) => p.isLowStock).toList()
        ..sort((a, b) => a.quantity.compareTo(b.quantity)),
      recentOrders: recent.take(4).toList(),
    );
  }

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);
}
