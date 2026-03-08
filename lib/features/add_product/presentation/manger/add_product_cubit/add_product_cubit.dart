import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/features/add_product/domain/entities/add_product_input_entity.dart';
import 'package:meta/meta.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ImageRepo imageRepo;
  final ProductRepo productRepo;

  AddProductCubit({required this.imageRepo, required this.productRepo})
    : super(AddProductInitial());

  Future<void> addProduct(AddProductInputEntity addProductInputEntity) async {
    emit(AddProductLoading());
    Either<Failure, String> result = await imageRepo.uploadImage(
      addProductInputEntity.image,
    );
    result.fold(
      (f) {
        emit(AddProductFailure(f.message));
      },
      (url) async {
        addProductInputEntity.imageUrl = url;
        Either<Failure, void> addProductResult = await productRepo.addProduct(
          addProductInputEntity: addProductInputEntity,
        );
        addProductResult.fold(
          (f) {
            emit(AddProductFailure(f.message));
          },
          (_) {
            emit(AddProductSuccess());
          },
        );
      },
    );

    // productRepo.addProduct(addProductInputEntity: addProductInputEntity);
  }
}
