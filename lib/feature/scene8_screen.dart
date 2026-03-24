import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene8Screen extends StatefulWidget {
  const Scene8Screen({super.key});

  @override
  State<Scene8Screen> createState() => _Scene8ScreenState();
}

class _Scene8ScreenState extends State<Scene8Screen> {
  final TextEditingController controller = TextEditingController();

  final state = SimulationState();
  final ai = SimulationAIService();

  String aiFeedback = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    generateAI();
  }

  Future<void> generateAI() async {
    try {
      final summary = """
Organisasi: ${state.orgName}
Budaya: ${state.orgData["Budaya"]}
Motivasi: ${state.orgData["Motivasi Tim"]}

Gaya: ${state.leadershipType}
Control: ${state.controlLevel}

Team Decision: ${state.teamDecision}
Crisis: ${state.crisisResult}
""";

      final res = await ai.generateCoaching(summary);

      setState(() {
        aiFeedback = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        aiFeedback = "Gagal memuat feedback AI.";
        isLoading = false;
      });
    }
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
                  Color(0xFFF5F3FF),
                  Color(0xFFEDE9FE),
                  Color(0xFFF8FAFF),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),

                  const SizedBox(height: 20),

                  /// 🔥 AI FEEDBACK
                  _glass(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.psychology,
                                  color: Colors.purple),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  aiFeedback,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                  ).animate().fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 20),

                  /// REFLECTION INPUT
                  Text(
                    "Refleksi Anda:",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  _glass(
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Tuliskan pembelajaran Anda...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => _finishDialog(),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFFA78BFA),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Selesai",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn().scale(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎉 FINISH DIALOG
  Widget _finishDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
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
                const Icon(Icons.emoji_events,
                    size: 40, color: Colors.amber),

                const SizedBox(height: 10),

                Text(
                  "Simulasi Selesai",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),

                const SizedBox(height: 10),

                Text(
                  "Terima kasih telah menyelesaikan simulasi kepemimpinan.\n\n"
                  "Pembelajaran Anda telah direkam.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Kembali ke Home"),
                )
              ],
            ),
          ),
        ),
      ),
    ).animate().scale().fadeIn();
  }

  /// HEADER
  Widget _header() {
    return Row(
      children: [
        const Icon(Icons.school, color: Colors.purple),
        const SizedBox(width: 10),
        Text(
          "AI Coaching",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  /// GLASS
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
}