import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animations/animations.dart';
import 'package:organova/core/theme/app_theme.dart';
import 'package:organova/core/widgets/organova_logo.dart';
import 'package:organova/feature/about_screen.dart';
import 'package:organova/feature/intro_screen.dart';
import 'package:organova/feature/materi_screen.dart';
import 'package:organova/feature/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double buttonScale = 1.0;
  late AnimationController bubbleController;

  @override
  void initState() {
    super.initState();

    bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    bubbleController.dispose();
    super.dispose();
  }

  /// 🚀 NAVIGASI
  void _goToIntro() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const IntroScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(animation: animation, child: child);
        },
      ),
    );
  }

  void _goToMateri() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const MateriScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(animation: animation, child: child);
        },
      ),
    );
  }

  void _goToAbout() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const AboutScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(animation: animation, child: child);
        },
      ),
    );
  }

  void _goToQuiz() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const QuizScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeScaleTransition(animation: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌈 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEEF2FF),
                  Color(0xFFE0E7FF),
                  Color(0xFFF8FAFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// 🫧 FLOATING BUBBLE
          AnimatedBuilder(
            animation: bubbleController,
            builder: (_, __) {
              final v = bubbleController.value;

              return Stack(
                children: [
                  _bubble(40 + v * 20, v * 400, 90),
                  _bubble(200 - v * 30, v * 500, 70),
                  _bubble(120 + v * 15, v * 450, 110),
                  _bubble(300 - v * 25, v * 420, 80),
                ],
              );
            },
          ),

          /// 📱 CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER LOGO & STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const OrganovaLogo(iconSize: 40, isHorizontal: true),
                      _glass(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "120 XP",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideY(begin: -0.3),

                  const SizedBox(height: 22),

                  /// HERO CARD
                  _glass(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Datang!",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: AppColors.textDark,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Simulasi Kepemimpinan & Pengambilan Keputusan Organisasi Berbasis AI",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textDarkSecondary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Feature chips
                              Wrap(
                                spacing: 6,
                                children: [
                                  _chip(
                                    "AI-Powered",
                                    Icons.auto_awesome,
                                    const Color(0xFF6366F1),
                                  ),
                                  _chip(
                                    "Interaktif",
                                    Icons.touch_app,
                                    const Color(0xFF0EA5E9),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 88,
                          child: Lottie.asset("assets/ai.json"),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),

                  const SizedBox(height: 22),

                  /// 🚀 CTA BUTTON SIMULASI
                  GestureDetector(
                    onTapDown: (_) => setState(() => buttonScale = 0.95),
                    onTapUp: (_) {
                      setState(() => buttonScale = 1);
                      _goToIntro();
                    },
                    onTapCancel: () => setState(() => buttonScale = 1),
                    child: AnimatedScale(
                      scale: buttonScale,
                      duration: const Duration(milliseconds: 120),
                      child: Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A6CF7), Color(0xFF7B8CFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4A6CF7).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "MULAI SIMULASI",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).scale(),

                  const SizedBox(height: 32),

                  /// SECTION HEADING
                  Row(
                    children: [
                      Text(
                        "Menu Belajar",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 1,
                        width: 40,
                        color: AppColors.brandIndigo.withOpacity(0.3),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🎮 MENU GRID
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      _menu(
                        "Materi",
                        Icons.menu_book_rounded,
                        const Color(0xFF3B82F6),
                        "Pelajari teori kepemimpinan",
                        _goToMateri,
                      ),
                      _menu(
                        "Kuis",
                        Icons.quiz_rounded,
                        const Color(0xFFF59E0B),
                        "Uji pemahaman Anda",
                        _goToQuiz,
                      ),
                      _menu(
                        "Tentang",
                        Icons.info_rounded,
                        const Color(0xFF8B5CF6),
                        "Tentang Organova",
                        _goToAbout,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🏷️ CHIP
  Widget _chip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 🫧 BUBBLE
  Widget _bubble(double x, double y, double size) {
    return Positioned(
      left: x,
      bottom: y - 150,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color(0xFF4A6CF7).withOpacity(0.12),
              Colors.transparent,
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// 🧊 GLASS
  Widget _glass({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  /// 🎯 MENU CARD
  Widget _menu(
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return _PressableCard(
      child: GestureDetector(
        onTap: onTap,
        child: _glass(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDarkMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale();
  }
}

/// 🔥 PRESS EFFECT
class _PressableCard extends StatefulWidget {
  final Widget child;
  const _PressableCard({required this.child});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) => setState(() => scale = 1),
      onTapCancel: () => setState(() => scale = 1),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
