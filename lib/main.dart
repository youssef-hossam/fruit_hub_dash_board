import 'package:flutter/material.dart';

import 'package:fruit_hub_dash_board/app.dart';
import 'package:fruit_hub_dash_board/core/services/get_it_service.dart';
import 'package:fruit_hub_dash_board/core/services/supabase_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseStorageService().initSupabase();
  setupLocator();
  runApp(FruitHubDashboard());
}
