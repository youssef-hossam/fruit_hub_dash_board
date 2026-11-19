import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/state_views.dart';
import 'package:fruit_hub_dash_board/core/widgets/status_chip.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/manger/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/views/order_details_view.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/views/widgets/order_card.dart';

/// Orders tab: every customer order, filtered by status.
class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  OrderStatus? _status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersFailure) {
          return ErrorView(
            message: state.message,
            onRetry: context.read<OrdersCubit>().load,
          );
        }
        if (state is! OrdersLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green1500),
          );
        }
        final all = state.orders;
        final orders = _status == null
            ? all
            : all.where((o) => o.status == _status).toList();

        return Column(
          children: [
            SizedBox(
              height: 52,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                scrollDirection: Axis.horizontal,
                children: [
                  _StatusTab(
                    label: 'الكل',
                    count: all.length,
                    color: AppColors.green1500,
                    selected: _status == null,
                    onTap: () => setState(() => _status = null),
                  ),
                  for (final s in OrderStatus.values)
                    _StatusTab(
                      label: s.label,
                      count: all.where((o) => o.status == s).length,
                      color: statusColor(s),
                      selected: _status == s,
                      onTap: () => setState(() => _status = s),
                    ),
                ],
              ),
            ),
            Expanded(
              child: orders.isEmpty
                  ? const EmptyView(
                      icon: Icons.receipt_long_rounded,
                      message: 'مفيش طلبات في الحالة دي',
                    )
                  : RefreshIndicator(
                      color: AppColors.green1500,
                      onRefresh: context.read<OrdersCubit>().load,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        itemCount: orders.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) => OrderCard(
                          order: orders[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailsView(orderId: orders[i].id),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({
    required this.label,
    required this.count,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int count;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : const Color(0xffE6E9EA),
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppStyles.bodySmallBold.copyWith(
                  color: selected ? Colors.white : AppColors.grayscale600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: AppStyles.bodyXSmallBold.copyWith(
                    color: selected ? Colors.white : color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
