import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/core/services/get_it_service.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/manger/add_product_cubit/add_product_cubit.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/add_product_view_body.dart';

/// Add a new product, or edit [product] when it is passed.
class AddProductView extends StatelessWidget {
  static const String routeName = 'add_product';
  const AddProductView({super.key, this.product});

  final ProductEntity? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8F8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffF7F8F8),
        surfaceTintColor: Colors.transparent,
        title: Text(
          product == null ? 'إضافة منتج' : 'تعديل المنتج',
          style: AppStyles.bodyLargeBold,
        ),
      ),
      body: BlocProvider(
        create: (_) => AddProductCubit(productRepo: getIt<ProductRepo>()),
        child: AddProductViewBody(product: product),
      ),
    );
  }
}
