import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/add_product_view.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/dash_board_view.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/manger/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/views/orders_view.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/views/products_view.dart';

/// The dashboard shell: Home / Products / Orders with a bottom navigation bar.
class MainView extends StatefulWidget {
  const MainView({super.key, this.initialTab = 0});
  static const String routeName = 'main';
  final int initialTab;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late int _index = widget.initialTab;

  static const _titles = ['الرئيسية', 'المنتجات', 'الطلبات'];

  @override
  Widget build(BuildContext context) {
    final openOrders = context.select<OrdersCubit, int>(
      (c) => c.orders.where((o) => o.status.isOpen).length,
    );
    return Scaffold(
      backgroundColor: const Color(0xffF7F8F8),
      appBar: _index == 0
          ? null
          : AppBar(
              backgroundColor: const Color(0xffF7F8F8),
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              title: Text(_titles[_index], style: AppStyles.bodyLargeBold),
            ),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            DashBoardView(onOpenTab: (i) => setState(() => _index = i)),
            const ProductsView(),
            const OrdersView(),
          ],
        ),
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.green1500,
              foregroundColor: Colors.white,
              onPressed: () =>
                  Navigator.pushNamed(context, AddProductView.routeName),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'منتج جديد',
                style: AppStyles.bodySmallBold.copyWith(color: Colors.white),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.green1100,
        surfaceTintColor: Colors.white,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(
              Icons.space_dashboard_rounded,
              color: AppColors.green1500,
            ),
            label: 'الرئيسية',
          ),
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(
              Icons.inventory_2_rounded,
              color: AppColors.green1500,
            ),
            label: 'المنتجات',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: openOrders > 0,
              backgroundColor: AppColors.orange500,
              label: Text('$openOrders'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: openOrders > 0,
              backgroundColor: AppColors.orange500,
              label: Text('$openOrders'),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.green1500,
              ),
            ),
            label: 'الطلبات',
          ),
        ],
      ),
    );
  }
}
