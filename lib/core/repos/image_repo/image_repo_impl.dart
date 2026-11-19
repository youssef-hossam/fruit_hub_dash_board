import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo.dart';
import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';

class ImageRepoImpl implements ImageRepo {
  final StorageService storageService;

  ImageRepoImpl({required this.storageService});

  @override
  Future<Either<Failure, String>> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final url = await storageService.uploadImage(
        bytes: bytes,
        fileName: fileName,
        path: BackEndEndpoints.productImagesPath,
      );
      return Right(url);
    } catch (e) {
      log('Error uploading image: $e');
      return Left(ServerFailure('تعذر رفع الصورة: $e'));
    }
  }
}
