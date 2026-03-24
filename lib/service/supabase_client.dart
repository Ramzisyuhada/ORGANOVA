import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://ljvxxygxrspgqygfljpb.supabase.co',
      anonKey: 'sb_publishable_Btb6robhzw7X9t9E0wnOCg_zAsziyHE',
    );
  }
}