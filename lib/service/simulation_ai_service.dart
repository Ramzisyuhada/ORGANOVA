import 'package:organova/service/ai_service.dart';

import 'rag_service.dart';

class SimulationAIService {
  final mistral = MistralService();
  final rag = RagService();

  /// =========================
  /// 🔥 SCENE 2
  /// =========================
  Future<String> generateOrganization() async {
    final prompt = """

Anda adalah AI pembuat simulasi organisasi.

Tugas:
Buat 1 profil organisasi berdasarkan pilihan variabel berikut.

WAJIB:
- Output JSON valid
- Tanpa markdown
- Tanpa penjelasan tambahan
- Gunakan bahasa Indonesia sederhana

PILIHAN NILAI:

Budaya:
- Hierarkis
- Amburadul

Motivasi Tim:
- Rendah
- Tinggi

Pengalaman Karyawan:
- Tinggi

Tekanan Deadline:
- Tinggi

OUTPUT JSON:

{
  "name": "...",
  "culture": "...",
  "motivation": "...",
  "experience": "...",
  "deadline_pressure": "...",
  "description": "..."
}

ATURAN:
- culture HARUS salah satu dari: Hierarkis / Amburadul
- motivation HARUS salah satu dari: Rendah / Tinggi
- experience HARUS: Tinggi
- deadline_pressure HARUS: Tinggi
- description harus menjelaskan kondisi berdasarkan pilihan di atas (2 kalimat max)
- gunakan bahasa natural (tidak kaku)
""";

    return await mistral.generate(prompt);
  }

  /// =========================
  /// 🔥 SCENE 3
  /// =========================
  Future<String> analyzeLikert({
    required String userChoice,
    required Map<String, String> orgData,
  }) async {
    final prompt =
        """

Anda adalah AI analis kepemimpinan (Model Likert).

WAJIB:
- Output JSON VALID
- JANGAN gunakan tanda ``` atau markdown
- JANGAN tambahkan teks apapun selain JSON

DATA ORGANISASI:
Budaya: ${orgData["Budaya"]}
Motivasi Tim: ${orgData["Motivasi Tim"]}
Pengalaman: ${orgData["Pengalaman"]}
Deadline: ${orgData["Deadline"]}

Pilihan user:
$userChoice

OUTPUT JSON:

{
  "type": "...",
  "analysis": "...",
  "impact": "...",
  "feedback": "..."
}

ATURAN:
- type:
  Sistem 1 (Otoriter Eksploitif)
  Sistem 2 (Otoriter Bijak)
  Sistem 3 (Konsultatif)
  Sistem 4 (Partisipatif)

- Maksimal 2 kalimat per field
- Bahasa natural
""";

    return await mistral.generate(prompt);
  }

  /// =========================
  /// 🔥 SCENE 4
  /// =========================
  Future<String> analyzeContinuum({
    required double control,
    required Map<String, String> orgData,
  }) async {
    final prompt =
        """

Anda adalah AI simulasi kepemimpinan.

WAJIB:
- Output JSON VALID
- TANPA markdown
- TANPA enter / newline di dalam value JSON
- Semua teks dalam 1 baris per field

DATA ORGANISASI:
Budaya: ${orgData["Budaya"]}
Motivasi: ${orgData["Motivasi Tim"]}
Pengalaman: ${orgData["Pengalaman"]}
Deadline: ${orgData["Deadline"]}

Control Level: $control%

OUTPUT JSON:

{
  "category": "...",
  "team_impact": "...",
  "insight": "..."
}

ATURAN:
- WAJIB menggunakan Bahasa Indonesia untuk semua value (jangan bahasa Inggris)
- category HARUS salah satu dari (teori Leadership Continuum Tannenbaum & Schmidt):
  Otoriter (Tell) / Persuasif (Sell) / Konsultatif (Consult) / Partisipatif (Join) / Delegatif (Delegate)
- Control Level adalah posisi slider di aplikasi: 0 = pemimpin sangat otoriter, 100 = tim sangat bebas
  (label aplikasi: di bawah 30 Terlalu Otoriter, 30-70 Seimbang, di atas 70 Terlalu Bebas)
- Semua value HARUS 1 baris (tidak boleh enter)
- Maksimal 20 kata per field
""";
    return await mistral.generate(prompt);
  }

  /// =========================
  /// 🔥 SCENE 5
  /// =========================
  Future<String> analyzeTeam({
    required Map<String, String> teamDecision,
    required Map<String, String> orgData,
    required double control,
  }) async {
    final prompt =
        """

Anda adalah AI analis kepemimpinan (Hersey-Blanchard).

WAJIB:
- Output JSON VALID
- Tanpa markdown
- Tanpa teks tambahan

DATA ORGANISASI:
Budaya: ${orgData["Budaya"]}
Motivasi: ${orgData["Motivasi Tim"]}
Pengalaman: ${orgData["Pengalaman"]}
Deadline: ${orgData["Deadline"]}

Control Level: $control%

DATA TIM:
- Rina: Kompetensi rendah, Komitmen tinggi
- Budi: Kompetensi tinggi, Komitmen rendah
- Sari: Kompetensi tinggi, Komitmen tinggi

KEPUTUSAN USER:
${teamDecision.entries.map((e) => "${e.key}: ${e.value}").join("\n")}

OUTPUT JSON:

{
  "evaluation": "...",
  "mistakes": ["...", "..."],
  "recommendations": ["...", "..."]
}

ATURAN:
- evaluation: ringkasan penilaian
- mistakes: max 2 poin
- recommendations: max 2 poin
- bahasa sederhana
""";

    return await mistral.generate(prompt);
  }

  /// =========================
  /// 🔥 SCENE 6
  /// =========================
  Future<String> analyzeCrisis({
    required String strategy,
    required Map<String, String> orgData,
    required double control,
    required Map<String, String> teamDecision,
  }) async {
    final prompt =
        """

Anda adalah AI simulasi krisis organisasi.

WAJIB:
- Output JSON VALID
- Tanpa markdown
- Tanpa teks tambahan

DATA ORGANISASI:
Budaya: ${orgData["Budaya"]}
Motivasi: ${orgData["Motivasi Tim"]}
Pengalaman: ${orgData["Pengalaman"]}
Deadline: ${orgData["Deadline"]}

Control Level: $control%

Keputusan Tim:
${teamDecision.entries.map((e) => "${e.key}: ${e.value}").join("\n")}

SITUASI:
Perusahaan mengalami transformasi digital, konflik generasi, dan penurunan produktivitas.

Strategi user:
$strategy

OUTPUT JSON:

{
  "trust": 0,
  "productivity": 0,
  "resistance": "...",
  "analysis": "..."
}

ATURAN:
- trust & productivity: 0–100
- resistance: Low / Moderate / High
- analysis: max 2 kalimat
- bahasa natural
""";

    return await mistral.generate(prompt);
  }

  /// =========================
  /// 🔥 SCENE 7
  /// =========================
  Future<String> generateDashboard(String summary) async {
    final prompt =
        """

Anda adalah AI evaluator organisasi.

WAJIB:
- Output JSON VALID
- Tanpa markdown
- Tanpa teks tambahan

ATURAN PENILAIAN:
- team_trust: angka 0–100
- productivity: angka 0–100
- resistance: pilih salah satu dari ["low", "medium", "high"]
- leadership_fit: pilih salah satu dari ["low", "medium", "high"]

Data:
$summary

OUTPUT JSON:

{
  "team_trust": 0,
  "productivity": 0,
  "resistance": "low",
  "leadership_fit": "medium"
}
""";

    return await mistral.generate(prompt);
  }

  /// =========================
  /// 🔥 SCENE 8
  /// =========================
  Future<String> generateCoaching(String summary) async {
    final prompt =
        """

Anda adalah AI coach kepemimpinan.

WAJIB:
- Output TEXT saja (bukan JSON)
- Bahasa Indonesia natural
- Maksimal 120 kata
- Maksimal 2 paragraf
- Setiap poin singkat (1 kalimat)

Data simulasi:
$summary

Tugas:
Tuliskan secara ringkas:
1. Gaya kepemimpinan
2. Kelebihan utama
3. Area perbaikan utama
4. Saran praktis

Hindari penjelasan panjang dan bertele-tele.
Fokus langsung ke inti.

""";

    return await mistral.generate(prompt);
  }
}
