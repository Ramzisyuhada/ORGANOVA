import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/feature/scene3_screen.dart';
import 'package:organova/service/simulation_ai_service.dart';
import 'package:organova/statet/simulation_state.dart';

class Scene2Screen extends StatefulWidget {
  const Scene2Screen({super.key});

  @override
  State<Scene2Screen> createState() => _Scene2ScreenState();
}

class _Scene2ScreenState extends State<Scene2Screen> {
  final ai = SimulationAIService();

  Map<String, String> data = {};
  String orgName = "";

  String displayedText = "";
  String fullText = "";
  int charIndex = 0;
  bool isTyping = true;
  Timer? timer;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAIData();
  }

  /// 🔥 LOAD AI
  Future<void> loadAIData() async {
    try {
      final result = await ai.generateOrganization();
      final json = jsonDecode(result);
      final state = SimulationState();

      state.orgName = orgName;
      state.orgData = data;
      orgName = json["name"] ?? "Organisasi";

      data = {
        "Budaya": json["culture"],
        "Motivasi Tim": json["motivation"],
        "Pengalaman": json["experience"],
        "Deadline": json["deadline_pressure"],
      };

      fullText =
          "Bayangkan kamu adalah pemimpin di $orgName.\n\n"
          "${json["description"]}\n\n"
          "Dari kondisi ini, bagaimana kamu akan memimpin tim?";

      setState(() {
        isLoading = false;
      });

      startTyping();

    } catch (e) {
      fullText = "Gagal memuat data AI.";
      setState(() => isLoading = false);
    }
  }

  /// TYPE EFFECT
  void startTyping() {
    timer?.cancel();
    displayedText = "";
    charIndex = 0;
    isTyping = true;

    timer = Timer.periodic(const Duration(milliseconds: 20), (t) {
      if (charIndex < fullText.length) {
        setState(() {
          displayedText += fullText[charIndex];
          charIndex++;
        });
      } else {
        isTyping = false;
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [

                  /// HEADER
                  _header(),

                  const SizedBox(height: 20),

                  /// TEXT AI
                  _glass(
                    child: Text(
                      displayedText + (isTyping ? "|" : ""),
                      style: GoogleFonts.poppins(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DATA LIST (FIX OVERFLOW)
                  _glass(
                    child: Column(
                      children: data.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  e.key,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  e.value,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON
                  ElevatedButton(
                    onPressed: () {
                      _goToMateri();
                    },
                    child: const Text("Lanjut"),
                  ),
                ],
              ),
            ),
    );
  }

  /// HEADER
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ORGANIZATION PROFILE",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
          orgName,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  void _goToMateri() {
     Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scene3Screen(
        orgData: data,
        orgName: orgName,
      ),
    ),
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
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }
}