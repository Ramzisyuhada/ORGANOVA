import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animations/animations.dart';
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
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
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
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
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
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
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
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
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

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Level 1",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      _glass(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          child: Text("⭐ 120 XP"),
                        ),
                      )
                    ],
                  ).animate().fadeIn().slideY(begin: -0.3),

                  const SizedBox(height: 20),

                  /// HERO
                  _glass(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Stevi",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Belajar HR dengan simulasi cerdas",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Lottie.asset("assets/ai.json"),
                        )
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

                  const SizedBox(height: 30),

                  /// 🚀 BUTTON SIMULASI
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
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4A6CF7),
                              Color(0xFF7B8CFF),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "MULAI SIMULASI",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(),

                  const SizedBox(height: 30),

                  Text(
                    "Menu Belajar",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🎮 MENU GRID
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _menu("Materi", Icons.menu_book, Colors.blue, _goToMateri),
                      _menu("Kuis", Icons.quiz, Colors.orange,_goToQuiz ),
                      _menu("Tentang", Icons.info, Colors.purple, _goToAbout),
                    ],
                  ),
                ],
              ),
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
              Colors.white.withOpacity(0.25),
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
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: child,
        ),
      ),
    );
  }

  /// 🎯 MENU CARD (FIX NAVIGASI)
  Widget _menu(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return _PressableCard(
      child: GestureDetector(
        onTap: onTap,
        child: _glass(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 10),
              Text(title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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