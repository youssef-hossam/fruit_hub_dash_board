import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/app_network_image.dart';
import 'package:fruit_hub_dash_board/core/widgets/state_views.dart';
import 'package:fruit_hub_dash_board/core/widgets/status_chip.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/manger/orders_cubit/orders_cubit.dart';

/// Full order: customer, items, totals and the status timeline. The admin
/// moves the order forward here and the customer sees it in the app.
class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersCubit>().orders;
    final match = orders.where((o) => o.id == orderId);
    if (match.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyView(
          icon: Icons.receipt_long_rounded,
          message: 'الطلب مش موجود',
        ),
      );
    }
    final order = match.first;
    final next = order.status.next;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F8F8),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text('طلب ${order.id}', style: AppStyles.bodyLargeBold),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
        children: [
          _Box(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      statusIcon(order.status),
                      color: statusColor(order.status),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.status.label,
                      style: AppStyles.bodyBaseBold.copyWith(
                        color: statusColor(order.status),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDateTime(order.createdAt),
                      textDirection: TextDirection.ltr,
                      style: AppStyles.bodyXSmallSemiBold.copyWith(
                        color: AppColors.grayscale400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Timeline(status: order.status),
              ],
            ),
          ),
          _Box(
            title: 'العميل',
            child: Column(
              children: [
                _InfoLine(
                  icon: Icons.person_rounded,
                  text: order.address.fullName,
                ),
                _InfoLine(
                  icon: Icons.phone_rounded,
                  text: order.address.phone,
                ),
                _InfoLine(
                  icon: Icons.location_on_rounded,
                  text:
                      '${order.address.address}، ${order.address.city}\n${order.address.floor}',
                ),
                _InfoLine(
                  icon: order.paymentMethod == 'card'
                      ? Icons.credit_card_rounded
                      : Icons.payments_rounded,
                  text: order.paymentMethod == 'card'
                      ? 'دفع بالبطاقة'
                      : 'الدفع عند الاستلام',
                ),
              ],
            ),
          ),
          _Box(
            title: 'المنتجات (${order.itemsCount})',
            child: Column(
              children: [
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        AppNetworkImage(
                          url: item.imageUrl,
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: AppStyles.bodySmallBold.copyWith(
                                  color: AppColors.grayscale950,
                                ),
                              ),
                              Text(
                                '${item.quantity} ${item.unit} × ${formatPrice(item.price)}',
                                style: AppStyles.bodyXSmallSemiBold.copyWith(
                                  color: AppColors.grayscale400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatPrice(item.total),
                          style: AppStyles.bodySmallBold.copyWith(
                            color: AppColors.grayscale950,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 22),
                _TotalLine(label: 'المجموع', value: order.subtotal),
                _TotalLine(label: 'التوصيل', value: order.deliveryFee),
                _TotalLine(label: 'الإجمالي', value: order.total, bold: true),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: order.status.isOpen
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xffE45556),
                          side: const BorderSide(color: Color(0xffF5C2C2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => _cancel(context, order),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (next != null)
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: statusColor(next),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => _move(context, order, next),
                            icon: Icon(statusIcon(next)),
                            label: Text(
                              'تحويل إلى "${next.label}"',
                              style: AppStyles.bodySmallBold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _move(
    BuildContext context,
    OrderEntity order,
    OrderStatus status,
  ) async {
    final error = await context.read<OrdersCubit>().updateStatus(order, status);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error == null ? statusColor(status) : null,
        content: Text(error ?? 'الطلب بقى "${status.label}" — العميل هيشوفه'),
      ),
    );
  }

  Future<void> _cancel(BuildContext context, OrderEntity order) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إلغاء الطلب؟'),
        content: Text('طلب ${order.id} هيتلغي وهيظهر ملغي عند العميل.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('رجوع'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xffE45556),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إلغاء الطلب'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await _move(context, order, OrderStatus.cancelled);
    }
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    const steps = [
      OrderStatus.pending,
      OrderStatus.preparing,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];
    final reached = status == OrderStatus.cancelled ? -1 : status.index;
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: i <= reached
                      ? AppColors.green1500
                      : AppColors.grayscale100,
                  child: Icon(
                    i <= reached ? Icons.check_rounded : statusIcon(steps[i]),
                    size: 16,
                    color: i <= reached ? Colors.white : AppColors.grayscale400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[i].label,
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyXSmallSemiBold.copyWith(
                    color: i <= reached
                        ? AppColors.green1500
                        : AppColors.grayscale400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.child, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffEEF0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppStyles.bodyBaseBold.copyWith(
                color: AppColors.grayscale950,
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.green1500),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppStyles.bodySmallsemiBold.copyWith(
                color: AppColors.grayscale700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  const _TotalLine({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = (bold ? AppStyles.bodyBaseBold : AppStyles.bodySmallsemiBold)
        .copyWith(
          color: bold ? AppColors.green1500 : AppColors.grayscale600,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(formatPrice(value), style: style),
        ],
      ),
    );
  }
}
