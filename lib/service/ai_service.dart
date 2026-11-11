import 'dart:convert';
import 'package:http/http.dart' as http;

class MistralService {
  /// Supplied at build time so the key never lives in source control:
  /// flutter run --dart-define-from-file=dart_defines.json
  static const String apiKey = String.fromEnvironment('MISTRAL_API_KEY');

  void _checkKey() {
    if (apiKey.isEmpty) {
      throw StateError(
        'MISTRAL_API_KEY kosong. Jalankan/build dengan '
        '--dart-define-from-file=dart_defines.json',
      );
    }
  }

  Future<String> generate(String prompt) async {
    _checkKey();
    final response = await http.post(
      Uri.parse("https://api.mistral.ai/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "open-mistral-nemo",
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.7,
      }),
    );

    final data = jsonDecode(response.body);
    final content = data["choices"][0]["message"]["content"] as String;
    return _stripCodeFence(content);
  }

  /// Some models wrap JSON answers in ```json ... ``` fences; remove them so
  /// callers can pass the result straight to jsonDecode.
  String _stripCodeFence(String text) {
    var t = text.trim();
    if (t.startsWith("```")) {
      final firstNewline = t.indexOf("\n");
      t = firstNewline == -1 ? "" : t.substring(firstNewline + 1);
      if (t.trimRight().endsWith("```")) {
        t = t.trimRight();
        t = t.substring(0, t.length - 3);
      }
    }
    return t.trim();
  }

  Future<List<double>> getEmbedding(String text) async {
    _checkKey();
    final response = await http.post(
      Uri.parse("https://api.mistral.ai/v1/embeddings"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({"model": "mistral-embed", "input": text}),
    );

    final data = jsonDecode(response.body);

    return List<double>.from(data['data'][0]['embedding']);
  }
}
