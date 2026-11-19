/// Demo mode runs the dashboard without Firebase / Supabase, on in-memory
/// sample data. Used for web previews and screenshots:
///   flutter run -d chrome --dart-define=DEMO=true
const bool kDemoMode = bool.fromEnvironment('DEMO');
