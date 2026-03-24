import 'dart:convert';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/scene5_screen.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene4Screen extends StatefulWidget {
  const Scene4Screen({super.key});

  @override
  State<Scene4Screen> createState() => _Scene4ScreenState();
}

class _Scene4ScreenState extends State<Scene4Screen> {
  final ai = SimulationAIService();
  final state = SimulationState();

  double sliderValue = 50;

  Map<String, dynamic>? result;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    /// 🔥 LOAD GLOBAL STATE
    if (state.controlLevel != 0) {
      sliderValue = state.controlLevel;
    }

    if (state.continuumResult != null) {
      result = state.continuumResult;
    }
  }

  /// 🔥 CLEAN JSON
  String cleanJson(String text) {
    return text
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .replaceAll(RegExp(r'[\n\r]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// 🔥 ANALYZE AI
  Future<void> analyzeAI() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final res = await ai.analyzeContinuum(
        control: sliderValue,
        orgData: state.orgData,
      );

      final cleaned = cleanJson(res);
      final decoded = jsonDecode(cleaned);

      setState(() {
        result = decoded;
      });

      /// 🔥 SAVE KE GLOBAL STATE
      state.continuumResult = decoded;

    } catch (e) {
      debugPrint("AI ERROR: $e");
    }

    setState(() => isLoading = false);
  }

  /// LABEL
  String getLabel() {
    if (result != null) return result!["category"];
    if (sliderValue < 30) return "Terlalu Otoriter";
    if (sliderValue > 70) return "Terlalu Bebas";
    return "Seimbang";
  }

  Color getColor() {
    if (sliderValue < 30) return Colors.red;
    if (sliderValue > 70) return Colors.orange;
    return Colors.green;
  }

  /// FEEDBACK
  String getFeedback() {
    if (result != null) {
      return "${result!["team_impact"]}\n\n${result!["insight"]}";
    }
    return "Geser slider lalu klik tombol untuk analisis.";
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
                    value: 0.5,
                    color: const Color(0xFF4A6CF7),
                  ),

                  const SizedBox(height: 20),

                  _header(),

                  const SizedBox(height: 20),

                  /// CASE
                  _glass(
                    child: Text(
                      "Tim harus menyelesaikan proyek dengan cepat.\n"
                      "Atur tingkat kontrol Anda.",
                      style: GoogleFonts.poppins(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// LABEL
                  Center(
                    child: Text(
                      getLabel(),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: getColor(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SLIDER
                  Slider(
                    value: sliderValue,
                    min: 0,
                    max: 100,
                    activeColor: getColor(),
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                        result = null; // reset hasil lama
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// FEEDBACK PREVIEW
                  _glass(
                    child: Text(
                      getFeedback(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(),
                    ),
                  ),

                  const Spacer(),

                  /// 🔥 BUTTON ALL-IN-ONE
                  GestureDetector(
                    onTap: () async {
                      state.controlLevel = sliderValue;

                      if (result == null) {
                        await analyzeAI();
                      }

                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Gagal analisis, coba lagi")),
                        );
                        return;
                      }

                      /// 🔥 SAVE FINAL STATE
                      state.continuumResult = result;

                      showFeedbackDialog();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            getColor(),
                            getColor().withOpacity(0.7)
                          ],
                        ),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Analisis & Lanjut",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 POPUP FEEDBACK
  void showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// CATEGORY
                  Text(
                    result!["category"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: getColor(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// IMPACT
                  Text(
                    result!["team_impact"],
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  /// INSIGHT
                  Text(
                    result!["insight"],
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _goToMateri();
                    },
                    child: const Text("Lanjut"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goToMateri() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const Scene5Screen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// HEADER
  Widget _header() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF4A6CF7), Color(0xFF7B8CFF)],
            ),
          ),
          child: const Icon(Icons.tune, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Leadership Control",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Adjust your authority level",
                style: GoogleFonts.poppins(fontSize: 12)),
          ],
        )
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