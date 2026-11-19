import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/entities/review_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/app_network_image.dart';
import 'package:fruit_hub_dash_board/core/widgets/state_views.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/add_product_view.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/manger/products_cubit/products_cubit.dart';

/// Read-only view of a product the way customers see it, plus its sales,
/// stock and reviews, with Edit / Delete actions.
class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsCubit>().products;
    final matches = products.where((p) => p.id == productId);
    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyView(
          icon: Icons.inventory_2_outlined,
          message: 'المنتج ده اتحذف',
        ),
      );
    }
    final p = matches.first;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            leading: const _RoundBack(),
            actions: [
              IconButton(
                tooltip: p.isFeatured ? 'إلغاء التمييز' : 'تمييز',
                onPressed: () =>
                    context.read<ProductsCubit>().toggleFeatured(p),
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    p.isFeatured
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: p.isFeatured
                        ? AppColors.orange500
                        : AppColors.grayscale400,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.green150,
                padding: const EdgeInsets.fromLTRB(40, 70, 40, 20),
                child: Hero(
                  tag: 'p-${p.id}',
                  child: AppNetworkImage(url: p.imageUrl, radius: 24),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            sliver: SliverList.list(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: AppStyles.heading5Bold.copyWith(
                              color: AppColors.grayscale950,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            p.nameEn,
                            style: AppStyles.bodySmallsemiBold.copyWith(
                              color: AppColors.grayscale400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatPrice(p.price),
                          style: AppStyles.bodyLargeBold.copyWith(
                            color: AppColors.orange500,
                          ),
                        ),
                        if (p.hasDiscount)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatPrice(p.oldPrice!),
                                style: AppStyles.bodyXSmallSemiBold.copyWith(
                                  color: AppColors.grayscale400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              _Tag(
                                text: 'خصم ${p.discountPercent}%',
                                color: const Color(0xffE45556),
                              ),
                            ],
                          ),
                        Text(
                          'لكل ${p.unit}',
                          style: AppStyles.bodyXSmallRegular.copyWith(
                            color: AppColors.grayscale400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(text: categoryLabel(p.category)),
                    _Tag(text: 'كود ${p.code}'),
                    if (p.isOrganic) const _Tag(text: 'أورجانيك 100%'),
                    if (p.isFeatured)
                      const _Tag(text: 'منتج مميز', color: AppColors.orange600),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Stat(
                      icon: Icons.shopping_cart_checkout_rounded,
                      value: '${p.sellingCount}',
                      label: 'مرة اتباع',
                    ),
                    const SizedBox(width: 10),
                    _Stat(
                      icon: Icons.star_rounded,
                      value: '${p.avgRating}',
                      label: '${p.ratingCount} تقييم',
                    ),
                    const SizedBox(width: 10),
                    _Stat(
                      icon: Icons.inventory_rounded,
                      value: '${p.quantity}',
                      label: 'في المخزن',
                      warn: p.isLowStock,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Stat(
                      icon: Icons.calendar_month_rounded,
                      value: '${p.expirationMonths}',
                      label: 'شهر صلاحية',
                    ),
                    const SizedBox(width: 10),
                    _Stat(
                      icon: Icons.local_fire_department_rounded,
                      value: '${p.numberOfCalories}',
                      label: 'سعر / 100 جم',
                    ),
                    const SizedBox(width: 10),
                    _Stat(
                      icon: Icons.payments_rounded,
                      value: _short(p.price * p.sellingCount),
                      label: 'إيراد (جنيه)',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'الوصف',
                  style: AppStyles.bodyBaseBold.copyWith(
                    color: AppColors.grayscale950,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.description,
                  style: AppStyles.bodySmallRegular.copyWith(
                    color: AppColors.grayscale600,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'آراء العملاء (${p.reviews.length})',
                  style: AppStyles.bodyBaseBold.copyWith(
                    color: AppColors.grayscale950,
                  ),
                ),
                const SizedBox(height: 8),
                if (p.reviews.isEmpty)
                  Text(
                    'لسه مفيش تقييمات',
                    style: AppStyles.bodySmallRegular.copyWith(
                      color: AppColors.grayscale400,
                    ),
                  ),
                for (final r in p.reviews) _ReviewTile(review: r),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              SizedBox(
                height: 52,
                width: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: const Color(0xffE45556),
                    side: const BorderSide(color: Color(0xffF5C2C2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _confirmDelete(context, p),
                  child: const Icon(Icons.delete_outline_rounded),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green1500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddProductView(product: p),
                      ),
                    ),
                    icon: const Icon(Icons.edit_rounded),
                    label: Text(
                      'تعديل المنتج',
                      style: AppStyles.bodyBaseBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _short(double v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : v.toStringAsFixed(0);

  Future<void> _confirmDelete(BuildContext context, ProductEntity p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف المنتج؟'),
        content: Text(
          '"${p.name}" هيختفي من التطبيق عند كل العملاء. متأكد؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xffE45556),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final error = await context.read<ProductsCubit>().delete(p.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'تم حذف "${p.name}"')),
    );
    if (error == null) Navigator.pop(context);
  }
}

class _RoundBack extends StatelessWidget {
  const _RoundBack();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.grayscale950,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, this.color = AppColors.green1500});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: AppStyles.bodyXSmallBold.copyWith(color: color)),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    this.warn = false,
  });
  final IconData icon;
  final String value;
  final String label;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final color = warn ? AppColors.orange600 : AppColors.green1500;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: warn ? AppColors.orange50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: warn ? AppColors.orange100 : const Color(0xffEEF0F0),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppStyles.bodyBaseBold.copyWith(
                color: AppColors.grayscale950,
                height: 1.2,
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
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffEEF0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.green1100,
            child: Text(
              review.name.characters.first,
              style: AppStyles.bodySmallBold.copyWith(
                color: AppColors.green1500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.name,
                        style: AppStyles.bodySmallBold.copyWith(
                          color: AppColors.grayscale950,
                        ),
                      ),
                    ),
                    for (var i = 0; i < 5; i++)
                      Icon(
                        i < review.rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 14,
                        color: AppColors.orange500,
                      ),
                  ],
                ),
                Text(
                  review.date,
                  style: AppStyles.bodyXSmallRegular.copyWith(
                    color: AppColors.grayscale400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  review.reviewDescription,
                  style: AppStyles.bodySmallRegular.copyWith(
                    color: AppColors.grayscale600,
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
