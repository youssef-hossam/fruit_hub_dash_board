import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_button.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/add_product_vierw.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key});
  static const String routeName = 'dash_board';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DashBoard')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AddProductView.routeName),
              text: 'Add Product',
            ),
          ],
        ),
      ),
    );
  }
}

// product data 

// name , price , description , image  isFeatured, productId 
