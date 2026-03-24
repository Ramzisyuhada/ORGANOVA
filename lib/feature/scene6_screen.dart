import 'dart:convert';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/scene7_screen.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene6Screen extends StatefulWidget {
  const Scene6Screen({super.key});

  @override
  State<Scene6Screen> createState() => _Scene6ScreenState();
}

class _Scene6ScreenState extends State<Scene6Screen> {
  final ai = SimulationAIService();
  final state = SimulationState();

  int? selected;
  bool answered = false;
  bool isLoading = false;

  Map<String, dynamic>? result;

  final String crisis =
      "Perusahaan sedang melakukan transformasi digital.\n\n"
      "Karyawan senior merasa kehilangan peran.\n"
      "Tim muda ingin perubahan cepat.\n"
      "Produktivitas turun 18%.\n\n"
      "Apa keputusan Anda sebagai manager?";

  /// 🔥 OPTIONS (TEXT ONLY, TANPA IMPACT)
  final List<String> options = [
    "Fokus percepatan perubahan dan abaikan resistensi.",
    "Seimbangkan perubahan dengan pelatihan untuk senior.",
    "Tunda perubahan dan stabilkan tim dulu.",
  ];

  String cleanJson(String text) {
    return text
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .replaceAll(RegExp(r'[\n\r]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// 🔥 PILIH + AI
  Future<void> selectOption(int i) async {
    if (answered) return;

    setState(() {
      selected = i;
      answered = true;
      isLoading = true;
    });

    final res = await ai.analyzeCrisis(
      strategy: options[i],
      orgData: state.orgData,
      control: state.controlLevel,
      teamDecision: state.teamDecision,
    );

    final decoded = jsonDecode(cleanJson(res));

    setState(() {
      result = decoded;
      isLoading = false;
    });

    /// 🔥 SAVE GLOBAL STATE
    state.crisisStrategy = options[i];
    state.crisisResult = decoded;

    Future.delayed(const Duration(milliseconds: 500), () {
      showResult();
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: _resultCard(),
      ),
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
                  Color(0xFFFFF1F2),
                  Color(0xFFFFE4E6),
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
                    value: 0.85,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 20),

                  _header(),

                  const SizedBox(height: 20),

                  _glass(
                    child: Text(crisis),
                  ),

                  const SizedBox(height: 20),

                  /// OPTIONS
                  ...List.generate(options.length, (i) {
                    return GestureDetector(
                      onTap: () => selectOption(i),
                      child: _optionCard(
                        text: options[i],
                        indexOption: i,
                      ),
                    );
                  }),

                  const Spacer(),

                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// RESULT (AI)
  Widget _resultCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text("Dampak Keputusan",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18)),

            const SizedBox(height: 16),

            _metric("Team Trust", result!["trust"], Colors.blue),
            _metric("Productivity", result!["productivity"], Colors.green),

            const SizedBox(height: 10),

            Text("Resistance: ${result!["resistance"]}"),

            const SizedBox(height: 10),

            Text(result!["analysis"],
                textAlign: TextAlign.center),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _goToMateri,
              child: const Text("Lanjut"),
            )
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required String text,
    required int indexOption,
  }) {
    bool isSelected = indexOption == selected;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _glass(
        child: Row(
          children: [
            Icon(Icons.flash_on,
                color: isSelected ? Colors.red : Colors.grey),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }

  Widget _metric(String title, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        LinearProgressIndicator(
          value: value / 100,
          color: color,
        ),
      ],
    );
  }

  Widget _glass({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Icon(Icons.warning, color: Colors.red),
        const SizedBox(width: 10),
        Text("Crisis Simulation",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  void _goToMateri() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const Scene7Screen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
        },
      ),
    );
  }
}