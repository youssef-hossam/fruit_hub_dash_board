import 'dart:typed_data';

import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';

/// Pretends to upload in demo mode and hands back a sample product image.
class DemoStorageService implements StorageService {
  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
    required String path,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://raw.githubusercontent.com/youssef-hossam/fruit_hup_app/main/assets/products/peach.jpg';
  }
}
