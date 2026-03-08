import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/core/services/get_it_service.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/manger/add_product_cubit/add_product_cubit.dart';
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
      body: BlocProvider(
        create: (context) => AddProductCubit(
          imageRepo: getIt<ImageRepo>(),
          productRepo: getIt<ProductRepo>(),
        ),

        child: AddProductViewBody(),
      ),
    );
  }
}
