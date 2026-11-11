import 'dart:convert';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/core/widgets/ai_evaluation_sheet.dart';
import 'package:organova/feature/scene6_screen.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene5Screen extends StatefulWidget {
  const Scene5Screen({super.key});

  @override
  State<Scene5Screen> createState() => _Scene5ScreenState();
}

class _Scene5ScreenState extends State<Scene5Screen> {
  final ai = SimulationAIService();
  final state = SimulationState();

  /// 👥 TEAM DATA
  final List<Map<String, dynamic>> team = [
    {"name": "Rina", "competence": "Rendah", "commitment": "Tinggi"},
    {"name": "Budi", "competence": "Tinggi", "commitment": "Rendah"},
    {"name": "Sari", "competence": "Tinggi", "commitment": "Tinggi"},
  ];

  /// 🎯 USER CHOICE
  Map<String, String> choices = {};

  /// 🎮 STYLE OPTIONS
  final List<String> styles = [
    "Telling (M1)",
    "Selling (M2)",
    "Participating (M3)",
    "Delegating (M4)",
  ];

  Map<String, dynamic>? result;
  bool isLoading = false;

  String cleanJson(String text) {
    return text
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .replaceAll(RegExp(r'[\n\r]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void selectStyle(String name, String style) {
    setState(() {
      choices[name] = style;
    });
  }

  /// 🔥 AI ANALYZE
  Future<void> analyzeAI() async {
    setState(() => isLoading = true);

    final res = await ai.analyzeTeam(
      teamDecision: choices,
      orgData: state.orgData,
      control: state.controlLevel,
    );

    final decoded = jsonDecode(cleanJson(res));

    setState(() {
      result = decoded;
      isLoading = false;
    });

    /// 🔥 SAVE GLOBAL STATE
    state.teamDecision = choices;
    state.teamResult = decoded;
  }

  void showResult() {
    if (result == null) return;
    AIEvaluationSheet.show(
      context,
      title: "Evaluasi AI - Readiness Analysis",
      subtitle: "Penilaian kecocokan gaya kepemimpinan tim",
      evaluationText: result!["evaluation"]?.toString(),
      mistakes: result!["mistakes"] is List ? result!["mistakes"] : null,
      recommendations: result!["recommendations"] is List
          ? result!["recommendations"]
          : null,
      onContinue: () {
        Navigator.pop(context);
        _goToMateri();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEEF2FF),
                  Color(0xFFE0E7FF),
                  Color(0xFFF8FAFF),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: 0.7,
                    color: const Color(0xFF4A6CF7),
                  ),

                  const SizedBox(height: 20),

                  _header(),

                  const SizedBox(height: 20),

                  /// TEAM LIST
                  Expanded(
                    child: ListView(
                      children: team.map((member) {
                        return _memberCard(member);
                      }).toList(),
                    ),
                  ),

                  /// BUTTON
                  GestureDetector(
                    onTap: () async {
                      /// VALIDASI
                      if (choices.length < 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Pilih semua anggota tim"),
                          ),
                        );
                        return;
                      }

                      await analyzeAI();
                      showResult();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A6CF7), Color(0xFF7B8CFF)],
                        ),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Analisis AI",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 👤 MEMBER CARD
  Widget _memberCard(Map member) {
    String name = member["name"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: _glass(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _tag("Kompetensi: ${member["competence"]}"),
                const SizedBox(width: 8),
                _tag("Komitmen: ${member["commitment"]}"),
              ],
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: styles.map((s) {
                bool selected = choices[name] == s;

                return GestureDetector(
                  onTap: () => selectStyle(name, s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        color: selected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// RESULT AI
  Widget _resultCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Evaluasi AI",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(result!["evaluation"], textAlign: TextAlign.center),

              const SizedBox(height: 10),

              Text(
                "Kesalahan:\n• ${result!["mistakes"].join("\n• ")}",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                "Rekomendasi:\n• ${result!["recommendations"].join("\n• ")}",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _goToMateri,
                child: const Text("Lanjut"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }

  Widget _glass({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Icon(Icons.groups, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          "Team Readiness Analysis",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  void _goToMateri() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const Scene6Screen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(animation: animation, child: child);
        },
      ),
    );
  }
}
