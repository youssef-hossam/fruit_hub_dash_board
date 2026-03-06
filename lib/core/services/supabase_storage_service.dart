import 'dart:io';

import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as b;

class SupabaseStorageService implements StorageService {
  late final Supabase _supabase;

  Future<void> initSupabase() async {
    _supabase = await Supabase.initialize(
      url: BackEndEndpoints.supabaseUrl,
      anonKey: BackEndEndpoints.supabaseAnonKey,
    );
  }

  @override
  Future<String> uploadImage(File file, String path) async {
    // Get the filename from the path
    final String fileName = b.basename(file.path);
    final String fileExtension = b.extension(file.path);

    var result = await _supabase.client.storage
        .from(BackEndEndpoints.fruitsBucketName)
        .upload('$path/$fileName.$fileExtension', file);

    return result;
  }
}
