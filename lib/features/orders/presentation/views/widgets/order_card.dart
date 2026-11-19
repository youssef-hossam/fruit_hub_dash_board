import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/app_network_image.dart';
import 'package:fruit_hub_dash_board/core/widgets/status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});
  final OrderEntity order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEEF0F0)),
          ),
          child: Row(
            children: [
              _Thumbs(items: order.items),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.id,
                          style: AppStyles.bodySmallBold.copyWith(
                            color: AppColors.grayscale950,
                          ),
                        ),
                        const Spacer(),
                        StatusChip(status: order.status),
                      ],
                    ),
                    Text(
                      order.address.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.bodySmallsemiBold.copyWith(
                        color: AppColors.grayscale600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${order.itemsCount} منتج • ${timeAgo(order.createdAt)}',
                          style: AppStyles.bodyXSmallRegular.copyWith(
                            color: AppColors.grayscale400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatPrice(order.total),
                          style: AppStyles.bodySmallBold.copyWith(
                            color: AppColors.green1500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two overlapping product photos, like a small stack of the basket.
class _Thumbs extends StatelessWidget {
  const _Thumbs({required this.items});
  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final shown = items.take(2).toList();
    return SizedBox(
      width: 62,
      height: 60,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            PositionedDirectional(
              start: i * 12.0,
              top: i * 12.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: AppNetworkImage(
                  url: shown[i].imageUrl,
                  width: 42,
                  height: 42,
                  radius: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
