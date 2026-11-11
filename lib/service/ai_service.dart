import 'dart:convert';
import 'package:http/http.dart' as http;

/// Client for any OpenAI-compatible chat API (Requesty router, Mistral, ...).
///
/// Everything is supplied at build time so secrets never live in source control:
///   flutter run --dart-define-from-file=dart_defines.json
///
/// Keys read from that file:
///   AI_BASE_URL     e.g. https://router.requesty.ai/v1 (default: Mistral API)
///   AI_API_KEY      API key for AI_BASE_URL (falls back to MISTRAL_API_KEY)
///   AI_MODEL        chat model id, e.g. google/gemma-4-31b-it
///   AI_EMBED_MODEL  embedding model id (only used by RagService)
class MistralService {
  static const String baseUrl = String.fromEnvironment(
    'AI_BASE_URL',
    defaultValue: 'https://api.mistral.ai/v1',
  );
  static const String apiKey = String.fromEnvironment(
    'AI_API_KEY',
    defaultValue: String.fromEnvironment('MISTRAL_API_KEY'),
  );
  static const String model = String.fromEnvironment(
    'AI_MODEL',
    defaultValue: 'open-mistral-nemo',
  );
  static const String embedModel = String.fromEnvironment(
    'AI_EMBED_MODEL',
    defaultValue: 'mistral-embed',
  );

  /// Reasoning models can take ~30 s; give up well after that instead of
  /// leaving the screen loading forever.
  static const Duration _timeout = Duration(seconds: 90);

  void _checkKey() {
    if (apiKey.isEmpty) {
      throw StateError(
        'AI_API_KEY kosong. Jalankan/build dengan '
        '--dart-define-from-file=dart_defines.json',
      );
    }
  }

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      };

  /// Decodes the body and throws a readable error for non-2xx responses
  /// (e.g. 402 saldo habis, 429 batas permintaan).
  Map<String, dynamic> _decode(http.Response response) {
    final body = utf8.decode(response.bodyBytes);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("AI API ${response.statusCode}: $body");
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<String> generate(String prompt) async {
    _checkKey();
    final response = await http
        .post(
          Uri.parse("$baseUrl/chat/completions"),
          headers: _headers,
          body: jsonEncode({
            "model": model,
            "messages": [
              {"role": "user", "content": prompt},
            ],
            "temperature": 0.7,
          }),
        )
        .timeout(_timeout);

    final data = _decode(response);
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
    final response = await http
        .post(
          Uri.parse("$baseUrl/embeddings"),
          headers: _headers,
          body: jsonEncode({"model": embedModel, "input": text}),
        )
        .timeout(_timeout);

    final data = _decode(response);
    return List<double>.from(data['data'][0]['embedding']);
  }
}
