import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organova/core/theme/app_theme.dart';

/// ─────────────────────────────────────────────
/// AIEvaluationSheet — Redesigned v2
/// Modern, readable, no text overlapping
/// ─────────────────────────────────────────────
class AIEvaluationSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? evaluationText;
  final List<dynamic>? mistakes;
  final List<dynamic>? recommendations;
  final String? impactText;
  final String? insightText;
  final String? leadershipType;
  final Map<String, dynamic>? metrics;
  final VoidCallback onContinue;
  final String buttonText;

  const AIEvaluationSheet({
    super.key,
    this.title = "Evaluasi AI",
    this.subtitle = "Hasil analisis simulasi kepemimpinan",
    this.evaluationText,
    this.mistakes,
    this.recommendations,
    this.impactText,
    this.insightText,
    this.leadershipType,
    this.metrics,
    required this.onContinue,
    this.buttonText = "Lanjut",
  });

  /// Helper static method to display the evaluation popup cleanly
  static Future<void> show(
    BuildContext context, {
    String title = "Evaluasi AI",
    String? subtitle = "Hasil analisis simulasi kepemimpinan",
    String? evaluationText,
    List<dynamic>? mistakes,
    List<dynamic>? recommendations,
    String? impactText,
    String? insightText,
    String? leadershipType,
    Map<String, dynamic>? metrics,
    required VoidCallback onContinue,
    String buttonText = "Lanjut",
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: AIEvaluationSheet(
          title: title,
          subtitle: subtitle,
          evaluationText: evaluationText,
          mistakes: mistakes,
          recommendations: recommendations,
          impactText: impactText,
          insightText: insightText,
          leadershipType: leadershipType,
          metrics: metrics,
          onContinue: onContinue,
          buttonText: buttonText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxCardHeight = MediaQuery.of(context).size.height * 0.85;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxCardHeight),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1627).withOpacity(0.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: -4,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER SECTION
              _buildHeader(context),

              /// SCROLLABLE CONTENT AREA — prevents text overlapping & cutoff
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (leadershipType != null && leadershipType!.isNotEmpty)
                        _buildLeadershipBadge()
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: 0.1),

                      if (evaluationText != null && evaluationText!.isNotEmpty)
                        _buildSectionCard(
                          title: "RINGKASAN PENILAIAN",
                          icon: Icons.psychology_outlined,
                          iconColor: AppColors.info,
                          accentColor: AppColors.info,
                          content: _buildBodyText(evaluationText!),
                        ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.1),

                      if (impactText != null && impactText!.isNotEmpty)
                        _buildSectionCard(
                          title: "DAMPAK TIM & ORGANISASI",
                          icon: Icons.groups_outlined,
                          iconColor: AppColors.warning,
                          accentColor: AppColors.warning,
                          content: _buildBodyText(impactText!),
                        ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.1),

                      if (insightText != null && insightText!.isNotEmpty)
                        _buildSectionCard(
                          title: "INSIGHT KEPEMIMPINAN",
                          icon: Icons.auto_awesome,
                          iconColor: const Color(0xFFA855F7),
                          accentColor: const Color(0xFFA855F7),
                          content: _buildBodyText(insightText!),
                        ).animate().fadeIn(delay: 240.ms).slideY(begin: 0.1),

                      if (metrics != null && metrics!.isNotEmpty)
                        _buildMetricsSection()
                            .animate()
                            .fadeIn(delay: 320.ms)
                            .slideY(begin: 0.1),

                      if (mistakes != null && mistakes!.isNotEmpty)
                        _buildListSection(
                          title: "AREA PERBAIKAN",
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.error,
                          accentColor: AppColors.error,
                          items: mistakes!,
                          textColor: const Color(0xFFFECDD3),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                      if (recommendations != null &&
                          recommendations!.isNotEmpty)
                        _buildListSection(
                          title: "REKOMENDASI TINDAKAN",
                          icon: Icons.task_alt,
                          iconColor: AppColors.success,
                          accentColor: AppColors.success,
                          items: recommendations!,
                          textColor: const Color(0xFFA7F3D0),
                          numbered: true,
                        ).animate().fadeIn(delay: 480.ms).slideY(begin: 0.1),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              /// DIVIDER
              Container(height: 1, color: Colors.white.withOpacity(0.08)),

              /// FIXED BOTTOM CTA BUTTON
              _buildCTAButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ── HEADER ───────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A2744), Color(0xFF0D1627)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // AI Icon Badge
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.success.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Selesai",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── LEADERSHIP BADGE ─────────────────────────
  Widget _buildLeadershipBadge() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.18),
            const Color(0xFF6366F1).withOpacity(0.08),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF60A5FA).withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFF60A5FA),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TIPE KEPEMIMPINAN",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF60A5FA).withOpacity(0.8),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  leadershipType!,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF93C5FD),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BODY TEXT HELPER ─────────────────────────
  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.7,
        color: const Color(0xFFCBD5E1),
        letterSpacing: 0.1,
      ),
    );
  }

  // ── SECTION CARD ─────────────────────────────
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340).withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: iconColor, size: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: iconColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Divider
                    Container(height: 1, color: Colors.white.withOpacity(0.06)),
                    const SizedBox(height: 10),
                    // Body content — flexible, no overflow
                    content,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── LIST SECTION ─────────────────────────────
  Widget _buildListSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
    required List<dynamic> items,
    required Color textColor,
    bool numbered = false,
  }) {
    final validItems = items
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (validItems.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340).withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: iconColor, size: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: iconColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${validItems.length} item",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: iconColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(height: 1, color: Colors.white.withOpacity(0.06)),
                    const SizedBox(height: 10),
                    // List items — all use Expanded to prevent overflow
                    ...validItems.asMap().entries.map((entry) {
                      final i = entry.key;
                      final itemStr = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bullet or number
                            Container(
                              margin: const EdgeInsets.only(top: 3, right: 10),
                              width: numbered ? 20 : 8,
                              height: numbered ? 20 : 8,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: numbered
                                    ? iconColor.withOpacity(0.2)
                                    : iconColor,
                                shape: numbered
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                borderRadius: numbered
                                    ? BorderRadius.circular(6)
                                    : null,
                              ),
                              child: numbered
                                  ? Text(
                                      "${i + 1}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: iconColor,
                                      ),
                                    )
                                  : null,
                            ),
                            // Text — Expanded prevents horizontal overflow
                            Expanded(
                              child: Text(
                                itemStr,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  height: 1.55,
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── METRICS SECTION ──────────────────────────
  Widget _buildMetricsSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340).withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: const BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bar_chart_rounded,
                            color: AppColors.info,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "METRIK KINERJA",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.info,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(height: 1, color: Colors.white.withOpacity(0.06)),
                    const SizedBox(height: 12),
                    ...metrics!.entries.map((entry) {
                      final val = entry.value;
                      if (val is int || val is double) {
                        final num numVal = val as num;
                        final percent = (numVal / 100)
                            .clamp(0.0, 1.0)
                            .toDouble();
                        final color = percent >= 0.7
                            ? AppColors.success
                            : percent >= 0.4
                            ? AppColors.warning
                            : AppColors.error;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF94A3B8),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$numVal%",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: percent,
                                  minHeight: 7,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.08,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.key.replaceAll('_', ' ').toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$val",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF1F5F9),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── CTA BUTTON ───────────────────────────────
  Widget _buildCTAButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
