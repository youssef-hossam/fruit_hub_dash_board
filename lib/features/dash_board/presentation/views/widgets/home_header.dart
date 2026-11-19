import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/features/dash_board/domain/dashboard_stats.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.stats});
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final todayTotal = stats.last7Days.last.total;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.green1600, AppColors.green1500, Color(0xff123F25)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.green1500.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: -30,
            top: -40,
            child: _Bubble(size: 130, opacity: 0.08),
          ),
          PositionedDirectional(
            end: 60,
            bottom: -50,
            child: _Bubble(size: 90, opacity: 0.06),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أهلاً يوسف 👋',
                          style: AppStyles.bodyBaseBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'لوحة تحكم FruitHub',
                          style: AppStyles.bodyXSmallSemiBold.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (stats.openOrders > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orange500,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${stats.openOrders} طلب مفتوح',
                        style: AppStyles.bodyXSmallBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'إجمالي المبيعات',
                style: AppStyles.bodySmallsemiBold.copyWith(
                  color: Colors.white70,
                ),
              ),
              Text(
                formatPrice(stats.revenue),
                style: AppStyles.heading4Bold.copyWith(
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _Pill(
                    icon: Icons.today_rounded,
                    text: 'اليوم ${formatPrice(todayTotal)}',
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    icon: Icons.receipt_long_rounded,
                    text: 'متوسط الطلب ${formatPrice(stats.avgOrderValue.round())}',
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

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.bodyXSmallSemiBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
