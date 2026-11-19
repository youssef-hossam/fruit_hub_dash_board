import 'package:fruit_hub_dash_board/core/config/app_config.dart';
import 'package:fruit_hub_dash_board/core/demo/demo_database_service.dart';
import 'package:fruit_hub_dash_board/core/demo/demo_storage_service.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/image_repo/image_repo_impl.dart';
import 'package:fruit_hub_dash_board/core/repos/orders_repo/orders_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/orders_repo/orders_repo_impl.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo_impl.dart';
import 'package:fruit_hub_dash_board/core/services/database_service.dart';
import 'package:fruit_hub_dash_board/core/services/firestore_service.dart';
import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';
import 'package:fruit_hub_dash_board/core/services/supabase_storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<DatabaseService>(
    kDemoMode ? DemoDatabaseService() : FirebaseFirestoreService(),
  );
  getIt.registerSingleton<StorageService>(
    kDemoMode ? DemoStorageService() : SupabaseStorageService(),
  );

  getIt.registerSingleton<ImageRepo>(
    ImageRepoImpl(storageService: getIt<StorageService>()),
  );
  getIt.registerSingleton<ProductRepo>(
    ProductRepoImpl(
      databaseService: getIt<DatabaseService>(),
      imageRepo: getIt<ImageRepo>(),
    ),
  );
  getIt.registerSingleton<OrdersRepo>(
    OrdersRepoImpl(databaseService: getIt<DatabaseService>()),
  );
}
