import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo.dart';
import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';

class ImageRepoImpl implements ImageRepo {
  final StorageService storageService;

  ImageRepoImpl({required this.storageService});
  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final result = await storageService.uploadImage(image, 'images/products');

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(' Failed to upload image: ${e.toString()}'));
    }
  }
}
