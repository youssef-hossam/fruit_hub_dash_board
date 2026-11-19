import 'dart:typed_data';

abstract class StorageService {
  /// Uploads [bytes] under [path] and returns the public URL of the file.
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
    required String path,
  });
}
