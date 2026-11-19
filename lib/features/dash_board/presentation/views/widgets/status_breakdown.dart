import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/status_chip.dart';

/// One stacked bar showing how many orders sit in each status.
class StatusBreakdown extends StatelessWidget {
  const StatusBreakdown({super.key, required this.byStatus});
  final Map<OrderStatus, int> byStatus;

  @override
  Widget build(BuildContext context) {
    final total = byStatus.values.fold(0, (s, v) => s + v);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffEEF0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حالة الطلبات',
            style: AppStyles.bodyBaseBold.copyWith(
              color: AppColors.grayscale950,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  for (final e in byStatus.entries)
                    if (e.value > 0)
                      Expanded(
                        flex: e.value,
                        child: Container(color: statusColor(e.key)),
                      ),
                  if (total == 0)
                    const Expanded(
                      child: ColoredBox(color: AppColors.grayscale100),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              for (final e in byStatus.entries)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: statusColor(e.key),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${e.key.label} (${e.value})',
                      style: AppStyles.bodyXSmallSemiBold.copyWith(
                        color: AppColors.grayscale600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
