import 'dart:typed_data';

import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService implements StorageService {
  static late Supabase _supabase;

  static Future<void> initSupabase() async {
    _supabase = await Supabase.initialize(
      url: BackEndEndpoints.supabaseUrl,
      anonKey: BackEndEndpoints.supabaseAnonKey,
    );
  }

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
    required String path,
  }) async {
    // A timestamp keeps names unique, so re-uploading "apple.jpg" never
    // overwrites (or fails on) an existing file.
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(fileName)}';
    final storagePath = '$path/$name';
    final bucket = _supabase.client.storage.from(
      BackEndEndpoints.fruitsBucketName,
    );

    await bucket.uploadBinary(storagePath, bytes);
    return bucket.getPublicUrl(storagePath);
  }
}
