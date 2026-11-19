import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';

const _dayNames = [
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد',
];

/// Simple animated bar chart of the last 7 days — no chart package needed.
class SalesChart extends StatelessWidget {
  const SalesChart({super.key, required this.days});
  final List<({DateTime day, double total})> days;

  @override
  Widget build(BuildContext context) {
    final max = days.fold<double>(0, (m, d) => d.total > m ? d.total : m);
    final week = days.fold<double>(0, (s, d) => s + d.total);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffEEF0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مبيعات آخر 7 أيام',
                      style: AppStyles.bodyBaseBold.copyWith(
                        color: AppColors.grayscale950,
                      ),
                    ),
                    Text(
                      formatPrice(week),
                      style: AppStyles.bodySmallBold.copyWith(
                        color: AppColors.green1500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green150,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'أسبوعي',
                  style: AppStyles.bodyXSmallBold.copyWith(
                    color: AppColors.green1500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < days.length; i++)
                  Expanded(
                    child: _Bar(
                      value: max == 0 ? 0 : days[i].total / max,
                      label: _dayNames[days[i].day.weekday - 1],
                      amount: days[i].total,
                      highlight: i == days.length - 1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.label,
    required this.amount,
    required this.highlight,
  });
  final double value;
  final String label;
  final double amount;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (amount > 0)
            FittedBox(
              child: Text(
                amount >= 1000
                    ? '${(amount / 1000).toStringAsFixed(1)}k'
                    : amount.toStringAsFixed(0),
                style: AppStyles.bodyXSmallBold.copyWith(
                  color: highlight
                      ? AppColors.green1500
                      : AppColors.grayscale400,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Container(
              height: 6 + 96 * v,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: highlight
                      ? const [AppColors.green1500, AppColors.green1400]
                      : const [AppColors.green1100, AppColors.green1200],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              label,
              style: AppStyles.bodyXSmallSemiBold.copyWith(
                color: highlight
                    ? AppColors.green1500
                    : AppColors.grayscale400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
