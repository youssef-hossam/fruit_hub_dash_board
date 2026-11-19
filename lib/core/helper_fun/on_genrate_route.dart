import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/add_product_view.dart';
import 'package:fruit_hub_dash_board/features/main_layout/presentation/views/main_view.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AddProductView.routeName:
      return MaterialPageRoute(builder: (_) => const AddProductView());
    case MainView.routeName:
    default:
      return MaterialPageRoute(
        builder: (_) => MainView(initialTab: (settings.arguments as int?) ?? 0),
      );
  }
}
