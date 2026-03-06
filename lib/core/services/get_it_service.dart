import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo_impl.dart';
import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';
import 'package:fruit_hub_dash_board/core/services/supabase_storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<StorageService>(SupabaseStorageService());
  getIt.registerSingleton(
    ImageRepoImpl(storageService: getIt<StorageService>()),
  );
}
