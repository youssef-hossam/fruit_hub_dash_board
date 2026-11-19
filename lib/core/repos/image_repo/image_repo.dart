import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dash_board/core/errors/failures.dart';

abstract class ImageRepo {
  Future<Either<Failure, String>> uploadImage({
    required Uint8List bytes,
    required String fileName,
  });
}
