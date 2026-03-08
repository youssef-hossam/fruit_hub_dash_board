import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fruit_hub_dash_board/app.dart';
import 'package:fruit_hub_dash_board/core/services/get_it_service.dart';
import 'package:fruit_hub_dash_board/core/services/supabase_storage_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';
import 'package:fruit_hub_dash_board/core/utils/custom_obsrver.dart';
import 'package:fruit_hub_dash_board/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: BackEndEndpoints.supabaseUrl,
    anonKey: BackEndEndpoints.supabaseAnonKey,
  );

  setupLocator();

  Bloc.observer = CustomBlocObserver();
  runApp(FruitHubDashboard());
}
