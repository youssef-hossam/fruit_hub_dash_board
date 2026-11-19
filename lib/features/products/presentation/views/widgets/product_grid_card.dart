import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/app_network_image.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onToggleFeatured,
  });
  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onToggleFeatured;

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEEF0F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppNetworkImage(url: p.imageUrl, radius: 14),
                    ),
                    if (p.hasDiscount)
                      PositionedDirectional(
                        top: 6,
                        start: 6,
                        child: _Badge(
                          text: '-${p.discountPercent}%',
                          color: const Color(0xffE45556),
                        ),
                      ),
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: GestureDetector(
                        onTap: onToggleFeatured,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            p.isFeatured
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 20,
                            color: p.isFeatured
                                ? AppColors.orange500
                                : AppColors.grayscale300,
                          ),
                        ),
                      ),
                    ),
                    if (p.isOrganic)
                      PositionedDirectional(
                        bottom: 6,
                        start: 6,
                        child: _Badge(
                          text: 'أورجانيك',
                          color: AppColors.green1600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.bodySmallBold.copyWith(
                  color: AppColors.grayscale950,
                ),
              ),
              Row(
                children: [
                  Text(
                    formatPrice(p.price),
                    style: AppStyles.bodySmallBold.copyWith(
                      color: AppColors.orange500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (p.hasDiscount)
                    Flexible(
                      child: Text(
                        formatPrice(p.oldPrice!),
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.bodyXSmallRegular.copyWith(
                          color: AppColors.grayscale400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.orange500,
                  ),
                  Text(
                    ' ${p.avgRating}',
                    style: AppStyles.bodyXSmallBold.copyWith(
                      color: AppColors.grayscale600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'مخزون ${p.quantity}',
                    style: AppStyles.bodyXSmallBold.copyWith(
                      color: p.isLowStock
                          ? AppColors.orange600
                          : AppColors.grayscale400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppStyles.bodyXSmallBold.copyWith(color: Colors.white),
      ),
    );
  }
}
