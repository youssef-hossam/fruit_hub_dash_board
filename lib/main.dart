import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fruit_hub_dash_board/app.dart';
import 'package:fruit_hub_dash_board/core/config/app_config.dart';
import 'package:fruit_hub_dash_board/core/services/get_it_service.dart';
import 'package:fruit_hub_dash_board/core/services/supabase_storage_service.dart';
import 'package:fruit_hub_dash_board/core/utils/custom_obsrver.dart';
import 'package:fruit_hub_dash_board/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Demo mode (web previews / screenshots) runs on in-memory data.
  if (!kDemoMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await SupabaseStorageService.initSupabase();
  }

  setupLocator();

  Bloc.observer = CustomBlocObserver();
  runApp(const FruitHubDashboard());
}
