import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';

Color statusColor(OrderStatus status) => switch (status) {
      OrderStatus.pending => AppColors.orange500,
      OrderStatus.preparing => const Color(0xff3B82F6),
      OrderStatus.onTheWay => AppColors.green1600,
      OrderStatus.delivered => AppColors.green1500,
      OrderStatus.cancelled => const Color(0xffE45556),
    };

IconData statusIcon(OrderStatus status) => switch (status) {
      OrderStatus.pending => Icons.fiber_new_rounded,
      OrderStatus.preparing => Icons.inventory_2_rounded,
      OrderStatus.onTheWay => Icons.local_shipping_rounded,
      OrderStatus.delivered => Icons.check_circle_rounded,
      OrderStatus.cancelled => Icons.cancel_rounded,
    };

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: AppStyles.bodyXSmallBold.copyWith(color: color),
      ),
    );
  }
}
