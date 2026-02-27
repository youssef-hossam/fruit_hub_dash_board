import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/add_product_view_body.dart';

class AddProductView extends StatefulWidget {
  static const String routeName = 'add_product';
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: AddProductViewBody(),
    );
  }
}
