import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/state_views.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/manger/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/views/product_details_view.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/views/widgets/product_grid_card.dart';

/// Products tab: search, filter by category / featured / low stock, and open
/// a product to edit it.
class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

enum _Filter { all, featured, lowStock }

class _ProductsViewState extends State<ProductsView> {
  String _query = '';
  String? _category;
  _Filter _filter = _Filter.all;

  List<ProductEntity> _apply(List<ProductEntity> all) {
    final q = _query.trim().toLowerCase();
    return all.where((p) {
      if (_category != null && p.category != _category) return false;
      if (_filter == _Filter.featured && !p.isFeatured) return false;
      if (_filter == _Filter.lowStock && !p.isLowStock) return false;
      if (q.isEmpty) return true;
      return p.name.contains(q) ||
          p.nameEn.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsFailure) {
          return ErrorView(
            message: state.message,
            onRetry: context.read<ProductsCubit>().load,
          );
        }
        if (state is! ProductsLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green1500),
          );
        }
        final products = _apply(state.products);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SearchField(onChanged: (v) => setState(() => _query = v)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _Chip(
                            label: 'الكل',
                            selected: _category == null,
                            onTap: () => setState(() => _category = null),
                          ),
                          for (final e in kCategories.entries)
                            _Chip(
                              label: e.value,
                              selected: _category == e.key,
                              onTap: () => setState(() => _category = e.key),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '${products.length} منتج',
                          style: AppStyles.bodySmallBold.copyWith(
                            color: AppColors.grayscale600,
                          ),
                        ),
                        const Spacer(),
                        _FilterButton(
                          icon: Icons.star_rounded,
                          label: 'مميز',
                          selected: _filter == _Filter.featured,
                          onTap: () => setState(
                            () => _filter = _filter == _Filter.featured
                                ? _Filter.all
                                : _Filter.featured,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _FilterButton(
                          icon: Icons.inventory_rounded,
                          label: 'مخزون قليل',
                          selected: _filter == _Filter.lowStock,
                          onTap: () => setState(
                            () => _filter = _filter == _Filter.lowStock
                                ? _Filter.all
                                : _Filter.lowStock,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyView(
                  icon: Icons.search_off_rounded,
                  message: 'مفيش منتجات مطابقة',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverGrid.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.66,
                  ),
                  itemBuilder: (context, i) {
                    final p = products[i];
                    return ProductGridCard(
                      product: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsView(productId: p.id),
                        ),
                      ),
                      onToggleFeatured: () async {
                        final error = await context
                            .read<ProductsCubit>()
                            .toggleFeatured(p);
                        if (error != null && context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(error)));
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppStyles.bodySmallsemiBold,
      decoration: InputDecoration(
        hintText: 'ابحث بالاسم أو الكود…',
        hintStyle: AppStyles.bodySmallRegular.copyWith(
          color: AppColors.grayscale400,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.green1500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffEEF0F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffEEF0F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.green1500),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.green1500 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.green1500 : const Color(0xffE6E9EA),
            ),
          ),
          child: Text(
            label,
            style: AppStyles.bodySmallBold.copyWith(
              color: selected ? Colors.white : AppColors.grayscale600,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.orange600 : AppColors.grayscale400;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange50 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.orange200 : const Color(0xffE6E9EA),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppStyles.bodyXSmallBold.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
