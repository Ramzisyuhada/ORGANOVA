import 'dart:convert';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/scene4_screen.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene3Screen extends StatefulWidget {
  final Map<String, String> orgData;
  final String orgName;

  const Scene3Screen({
    super.key,
    required this.orgData,
    required this.orgName,
  });

  @override
  State<Scene3Screen> createState() => _Scene3ScreenState();
}

class _Scene3ScreenState extends State<Scene3Screen> {
  final ai = SimulationAIService();

  int? selected;
  bool answered = false;
  bool isLoading = false;

  Map<String, dynamic>? result;

  final String situation =
      "Tim mengalami konflik dan penurunan performa. "
      "Sebagai manager, Anda harus menentukan pendekatan awal.";
final List<String> options = [
  "Ikuti prosedur yang sudah ditentukan.",
  "Saya akan mendengar masukan Anda.",
  "Mari kita diskusikan solusi bersama."
];


  String cleanJson(String text) {
  return text
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .trim();
}



  /// 🔥 SELECT
  void selectOption(int i) async {
    if (answered) return;

    setState(() {
      selected = i;
      isLoading = true;
    });
    final state = SimulationState();
      final res = await ai.analyzeLikert(
      userChoice: options[i],
      orgData: widget.orgData,
    );

    setState(() {
      
      result = jsonDecode(cleanJson(res));
      answered = true;
      isLoading = false;
      
    });
    state.leadershipChoice = options[i];
    state.leadershipType = result?["type"];
    Future.delayed(const Duration(milliseconds: 300), () {
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
                    value: 0.35,
                    color: const Color(0xFF4A6CF7),
                  ),

                  const SizedBox(height: 20),

                  _header(),

                  const SizedBox(height: 20),

                  _glass(
                    child: Text(situation),
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

  /// RESULT CARD (AI VERSION)
  Widget _resultCard() {
    if (result == null) return const SizedBox();

    /// mapping warna biar tetap visual
    Color color = Colors.blue;
    if (result!["type"].contains("Sistem 1")) color = Colors.red;
    if (result!["type"].contains("Sistem 4")) color = Colors.green;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// TYPE
              Text(
                result!["type"],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),

              const SizedBox(height: 12),

              /// ANALYSIS
              Text(result!["analysis"], textAlign: TextAlign.center),

              const SizedBox(height: 10),

              /// IMPACT
              Text(result!["impact"], textAlign: TextAlign.center),

              const SizedBox(height: 10),

              /// FEEDBACK
              Text(result!["feedback"], textAlign: TextAlign.center),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _goToMateri,
                child: const Text("Lanjut"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.psychology, color: Colors.blue),
          const SizedBox(width: 10),
          Text("Leadership Diagnosis",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 6),

      /// 🔥 NAMA ORGANISASI
      Text(
        widget.orgName,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

 Widget _optionCard({
  required String text,
  required int indexOption,
}) {
  final labels = ["A", "B", "C"];
  bool isSelected = indexOption == selected;

  return GestureDetector(
    onTap: () => selectOption(indexOption),
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: _glass(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 LABEL A/B/C
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Text(
                labels[indexOption],
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _glass({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  void _goToMateri() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Scene4Screen()),
    );
  }
}