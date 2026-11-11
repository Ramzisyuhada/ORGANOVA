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
      final summary =
          """
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

                  /// 🔥 AI FEEDBACK CARD — redesigned with clear typography
                  _buildAIFeedbackCard(),

                  const SizedBox(height: 24),

                  /// REFLECTION INPUT SECTION
                  _buildReflectionSection(),

                  const SizedBox(height: 30),

                  /// FINISH BUTTON
                  _buildFinishButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── AI FEEDBACK CARD ──────────────────────────
  Widget _buildAIFeedbackCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1627),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.2),
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLoading ? _buildLoadingState() : _buildFeedbackContent(),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFA78BFA),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16),
            // Loading text handled by parent
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackContent() {
    // Parse paragraphs — split on double newline or single newline
    final paragraphs = aiFeedback
        .split(RegExp(r'\n\n|\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// CARD HEADER
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1040),
                const Color(0xFF0D1627).withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withOpacity(0.3),
                      const Color(0xFF6D28D9).withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFA78BFA),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AI Coaching & Insight",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Analisis personalisasi kepemimpinan Anda",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              // AI badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.35),
                    width: 1,
                  ),
                ),
                child: Text(
                  "AI",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFA78BFA),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// DIVIDER
        Container(height: 1, color: const Color(0xFF8B5CF6).withOpacity(0.15)),

        /// FEEDBACK TEXT CONTENT
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introductory label
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "FEEDBACK PERSONAL",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8B5CF6),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Render paragraphs with spacing — flexible, no overflow
              if (paragraphs.isEmpty)
                Text(
                  aiFeedback,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.75,
                    color: const Color(0xFFCBD5E1),
                    letterSpacing: 0.1,
                  ),
                )
              else
                ...paragraphs.asMap().entries.map((entry) {
                  final i = entry.key;
                  final para = entry.value;

                  // First paragraph gets slightly larger/bolder treatment
                  final isFirst = i == 0;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i < paragraphs.length - 1 ? 12 : 0,
                    ),
                    child: Text(
                      para,
                      style: GoogleFonts.poppins(
                        fontSize: isFirst ? 14.5 : 14,
                        fontWeight: isFirst ? FontWeight.w500 : FontWeight.w400,
                        height: 1.75,
                        color: isFirst
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFFCBD5E1),
                        letterSpacing: 0.1,
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  /// ── REFLECTION SECTION ────────────────────────
  Widget _buildReflectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "REFLEKSI ANDA",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF7C3AED),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Tuliskan pembelajaran dan insight Anda dari simulasi ini",
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        _glass(
          child: TextField(
            controller: controller,
            maxLines: 5,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              hintText: "Tuliskan pembelajaran Anda...",
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  /// ── FINISH BUTTON ─────────────────────────────
  Widget _buildFinishButton() {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (_) => _finishDialog());
      },
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              "Selesai Simulasi",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).scale();
  }

  /// 🎉 FINISH DIALOG
  Widget _finishDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 44,
                    color: Colors.amber,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Simulasi Selesai!",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Selamat! Anda telah menyelesaikan simulasi kepemimpinan.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Pembelajaran Anda telah berhasil direkam.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Kembali ke Home",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.school, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI Coaching",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: const Color(0xFF1E293B),
              ),
            ),
            Text(
              "Sesi akhir kepemimpinan",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
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
            color: Colors.white.withOpacity(0.28),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
