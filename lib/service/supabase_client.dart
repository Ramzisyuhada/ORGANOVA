import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  /// Values come from --dart-define-from-file=dart_defines.json.
  static Future<void> init() async {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }
}
