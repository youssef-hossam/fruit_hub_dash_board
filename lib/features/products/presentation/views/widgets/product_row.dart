import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/app_network_image.dart';

/// Compact product line used on the home screen (best sellers / low stock).
class ProductRow extends StatelessWidget {
  const ProductRow({
    super.key,
    required this.product,
    required this.trailing,
    this.rank,
    this.onTap,
  });
  final ProductEntity product;
  final Widget trailing;
  final int? rank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            if (rank != null) ...[
              SizedBox(
                width: 22,
                child: Text(
                  '$rank',
                  style: AppStyles.bodyBaseBold.copyWith(
                    color: rank == 1
                        ? AppColors.orange500
                        : AppColors.grayscale300,
                  ),
                ),
              ),
            ],
            AppNetworkImage(url: product.imageUrl, width: 46, height: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.bodySmallBold.copyWith(
                      color: AppColors.grayscale950,
                    ),
                  ),
                  Text(
                    '${formatPrice(product.price)} / ${product.unit}',
                    style: AppStyles.bodyXSmallSemiBold.copyWith(
                      color: AppColors.grayscale400,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
