import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/features/dash_board/domain/dashboard_stats.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key, required this.stats});
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.shopping_bag_rounded,
        'الطلبات',
        '${stats.ordersCount}',
        const Color(0xff3B82F6),
      ),
      (
        Icons.people_alt_rounded,
        'العملاء',
        '${stats.customers}',
        AppColors.orange500,
      ),
      (
        Icons.inventory_2_rounded,
        'المنتجات',
        '${stats.productsCount}',
        AppColors.green1600,
      ),
      (
        Icons.star_rounded,
        'متوسط التقييم',
        stats.avgRating.toStringAsFixed(1),
        const Color(0xffE9B308),
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.15,
      children: [
        for (final (icon, label, value, color) in items)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xffEEF0F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          value,
                          style: AppStyles.heading5Bold.copyWith(
                            color: AppColors.grayscale950,
                            height: 1.1,
                          ),
                        ),
                      ),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.bodyXSmallSemiBold.copyWith(
                          color: AppColors.grayscale400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
