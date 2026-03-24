import 'dart:convert';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/scene8_screen.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene7Screen extends StatefulWidget {
  const Scene7Screen({super.key});

  @override
  State<Scene7Screen> createState() => _Scene7ScreenState();
}

class _Scene7ScreenState extends State<Scene7Screen> {
  final state = SimulationState();
  final ai = SimulationAIService();

  Map<String, dynamic>? result;
  bool isLoading = true;

  String cleanJson(String text) {
    return text
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .replaceAll(RegExp(r'[\n\r]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final summary = """
Organisasi: ${state.orgName}
Budaya: ${state.orgData["Budaya"]}
Motivasi: ${state.orgData["Motivasi Tim"]}

Gaya: ${state.leadershipType}
Control: ${state.controlLevel}

Team: ${state.teamDecision}
Crisis: ${state.crisisResult}
""";

      final res = await ai.generateDashboard(summary);
      final decoded = jsonDecode(cleanJson(res));

      setState(() {
        result = decoded;
        isLoading = false;
      });

    } catch (e) {
      debugPrint("Dashboard AI error: $e");
      setState(() => isLoading = false);
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
                  Color(0xFFECFDF5),
                  Color(0xFFD1FAE5),
                  Color(0xFFF8FAFF),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _header(),

                        const SizedBox(height: 20),

                        Text(
                          "Hasil keputusan Anda telah dianalisis oleh AI.",
                          style: GoogleFonts.poppins(),
                        ).animate().fadeIn(),

                        const SizedBox(height: 20),

                        /// 🔥 METRICS AI
                        _metricCard(
                            "Team Trust", result?["team_trust"] ?? 0, Colors.blue),
                        _metricCard(
                            "Productivity", result?["productivity"] ?? 0, Colors.green),

                        const SizedBox(height: 10),

                        _statusCard("Resistance Level",
                            result?["resistance"] ?? "-", Colors.orange),

                        _statusCard("Leadership Fit",
                            result?["leadership_fit"] ?? "-", Colors.purple),

                        const Spacer(),

                        GestureDetector(
                          onTap: () => _goToMateri(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF34D399),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Lanjut ke Refleksi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn().scale()
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Icon(Icons.analytics, color: Colors.green),
        const SizedBox(width: 10),
        Text(
          "Performance Dashboard",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _metricCard(String title, int value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _glass(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: value / 100,
              color: color,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 6),
            Text("$value%",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _statusCard(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _glass(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3);
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

  void _goToMateri(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const Scene8Screen(),
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