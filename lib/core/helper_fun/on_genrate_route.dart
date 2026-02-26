import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/add_product_vierw.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/dash_board_view.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case DashBoardView.routeName:
      return MaterialPageRoute(builder: (_) => const DashBoardView());
    case AddProductView.routeName:
      return MaterialPageRoute(builder: (_) => const AddProductView());

    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
