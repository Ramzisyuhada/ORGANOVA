import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─────────────────────────────────────────────
/// ORGANOVA — Design Token & Theme System
/// ─────────────────────────────────────────────
class AppColors {
  // Brand Palette
  static const Color brandBlue = Color(0xFF3B82F6);
  static const Color brandIndigo = Color(0xFF4A6CF7);
  static const Color brandViolet = Color(0xFF8B5CF6);
  static const Color brandPurple = Color(0xFF7C3AED);

  // Dark Surface
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color surfaceDarkCard = Color(0xFF1E293B);
  static const Color surfaceDarkBorder = Color(0xFF334155);

  // Light Surface
  static const Color surfaceLight = Color(0xFFF8FAFF);
  static const Color surfaceLightCard = Color(0xFFFFFFFF);

  // Text — Dark Theme
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);

  // Text — Light Theme
  static const Color textDark = Color(0xFF0F172A);
  static const Color textDarkSecondary = Color(0xFF334155);
  static const Color textDarkMuted = Color(0xFF64748B);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF43F5E);
  static const Color info = Color(0xFF38BDF8);
}

class AppTextStyles {
  // ── HEADING ──────────────────────────────────
  static TextStyle heading1({Color? color}) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: color ?? AppColors.textDark,
  );

  static TextStyle heading2({Color? color}) => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
    color: color ?? AppColors.textDark,
  );

  static TextStyle heading3({Color? color}) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.35,
    color: color ?? AppColors.textDark,
  );

  // ── SUBHEADING ────────────────────────────────
  static TextStyle subheading({Color? color}) => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: color ?? AppColors.textDark,
  );

  static TextStyle sectionLabel({Color? color}) => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.3,
    color: color ?? AppColors.textMuted,
  );

  // ── BODY TEXT ─────────────────────────────────
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: color ?? AppColors.textDarkSecondary,
  );

  static TextStyle body({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: color ?? AppColors.textDarkSecondary,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color ?? AppColors.textDarkMuted,
  );

  // ── AI RESULT ─────────────────────────────────
  static TextStyle aiResult({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.1,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle aiHeading({Color? color}) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: color ?? Colors.white,
  );

  // ── CAPTION / HELPER ──────────────────────────
  static TextStyle caption({Color? color}) => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.4,
    color: color ?? AppColors.textMuted,
  );

  // ── CTA / BUTTON ──────────────────────────────
  static TextStyle ctaPrimary({Color? color}) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: color ?? Colors.white,
  );

  static TextStyle ctaSecondary({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: color ?? AppColors.brandIndigo,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandIndigo,
      primary: AppColors.brandIndigo,
      secondary: AppColors.brandViolet,
      surface: AppColors.surfaceLight,
    ),
    scaffoldBackgroundColor: AppColors.surfaceLight,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      titleTextStyle: AppTextStyles.heading3(color: AppColors.textDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandIndigo,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.ctaPrimary(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 4,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );
}
