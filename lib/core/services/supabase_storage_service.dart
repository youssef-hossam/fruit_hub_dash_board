import 'dart:io';

import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as b;

class SupabaseStorageService implements StorageService {
  final supabase = Supabase.instance.client;

  @override
  Future<String> uploadImage(File file, String path) async {
    final String fileName = b.basename(file.path);
    final String fileExtension = b.extension(file.path);

    var result = await supabase.storage
        .from(BackEndEndpoints.fruitsBucketName)
        .upload('$path/$fileName.$fileExtension', file);

    return result;
  }
}
