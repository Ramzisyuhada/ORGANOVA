import 'package:organova/service/ai_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RagService {
  final supabase = Supabase.instance.client;
  final mistral = MistralService();

  Future<String> getContext(String query) async {
    try {
      /// 🔥 1. EMBEDDING QUERY
      final embedding = await mistral.getEmbedding(query);

      /// 🔥 2. CALL RPC
      final response = await supabase.rpc(
  'match_documents',
  params: {
    'match_count': 3,
    'query_embedding': embedding,
  },
);

      final data = response as List;

      if (data.isEmpty) return "";

      /// 🔥 3. GABUNGKAN CONTEXT
      return data.map((e) => e['content']).join("\n\n");
    } catch (e) {
      print("RAG ERROR: $e");
      return "";
    }
  }
}