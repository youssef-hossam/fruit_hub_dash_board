import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/section_title.dart';
import 'package:fruit_hub_dash_board/core/widgets/state_views.dart';
import 'package:fruit_hub_dash_board/features/dash_board/domain/dashboard_stats.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/widgets/home_header.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/widgets/kpi_grid.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/widgets/sales_chart.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/widgets/status_breakdown.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/manger/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/views/order_details_view.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/views/widgets/order_card.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/manger/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/views/product_details_view.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/views/widgets/product_row.dart';

/// Home tab: sales overview built from the live products and orders.
class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key, required this.onOpenTab});
  static const String routeName = 'dash_board';

  /// Jumps to another tab of the main layout (1 = products, 2 = orders).
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final productsState = context.watch<ProductsCubit>().state;
    final ordersState = context.watch<OrdersCubit>().state;

    if (productsState is ProductsFailure || ordersState is OrdersFailure) {
      return ErrorView(
        message: productsState is ProductsFailure
            ? productsState.message
            : (ordersState as OrdersFailure).message,
        onRetry: () {
          context.read<ProductsCubit>().load();
          context.read<OrdersCubit>().load();
        },
      );
    }
    if (productsState is! ProductsLoaded || ordersState is! OrdersLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.green1500),
      );
    }

    final stats = DashboardStats.from(
      products: productsState.products,
      orders: ordersState.orders,
    );

    return RefreshIndicator(
      color: AppColors.green1500,
      onRefresh: () async {
        await Future.wait([
          context.read<ProductsCubit>().load(),
          context.read<OrdersCubit>().load(),
        ]);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          HomeHeader(stats: stats),
          const SizedBox(height: 16),
          KpiGrid(stats: stats),
          const SizedBox(height: 16),
          SalesChart(days: stats.last7Days),
          const SizedBox(height: 16),
          StatusBreakdown(byStatus: stats.byStatus),
          const SizedBox(height: 20),
          SectionTitle(
            title: 'أحدث الطلبات',
            action: 'عرض الكل',
            onTap: () => onOpenTab(2),
          ),
          const SizedBox(height: 10),
          for (final order in stats.recentOrders) ...[
            OrderCard(
              order: order,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsView(orderId: order.id),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          _Card(
            child: Column(
              children: [
                SectionTitle(
                  title: 'الأكثر مبيعًا',
                  action: 'كل المنتجات',
                  onTap: () => onOpenTab(1),
                ),
                const SizedBox(height: 6),
                for (var i = 0; i < stats.bestSellers.length; i++)
                  ProductRow(
                    product: stats.bestSellers[i],
                    rank: i + 1,
                    onTap: () => _openProduct(context, stats.bestSellers[i].id),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${stats.bestSellers[i].sellingCount}',
                          style: AppStyles.bodySmallBold.copyWith(
                            color: AppColors.grayscale950,
                          ),
                        ),
                        Text(
                          'مبيعات',
                          style: AppStyles.bodyXSmallRegular.copyWith(
                            color: AppColors.grayscale400,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (stats.lowStock.isNotEmpty) ...[
            const SizedBox(height: 16),
            _Card(
              color: const Color(0xffFFF8EE),
              borderColor: AppColors.orange100,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.orange600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'مخزون قارب على النفاد',
                          style: AppStyles.bodyBaseBold.copyWith(
                            color: AppColors.orange700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (final p in stats.lowStock)
                    ProductRow(
                      product: p,
                      onTap: () => _openProduct(context, p.id),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'باقي ${p.quantity}',
                          style: AppStyles.bodyXSmallBold.copyWith(
                            color: AppColors.orange700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openProduct(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailsView(productId: id)),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.color = Colors.white,
    this.borderColor = const Color(0xffEEF0F0),
  });
  final Widget child;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
