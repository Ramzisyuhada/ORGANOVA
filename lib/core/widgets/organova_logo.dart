import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─────────────────────────────────────────────
/// OrganovaLogo — Updated v2
/// Supports icon-only, horizontal, and vertical layouts
/// ─────────────────────────────────────────────
class OrganovaLogo extends StatelessWidget {
  final double iconSize;
  final bool showText;
  final bool isHorizontal;
  final Color? textColor;

  const OrganovaLogo({
    super.key,
    this.iconSize = 48.0,
    this.showText = true,
    this.isHorizontal = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? const Color(0xFF0F172A);

    final Widget iconWidget = Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(iconSize * 0.26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A6CF7).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize * 0.26),
        child: Image.asset(
          'assets/logo/organova_icon.png',
          width: iconSize,
          height: iconSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback widget if image fails to load
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.hub_rounded,
                color: Colors.white,
                size: iconSize * 0.55,
              ),
            );
          },
        ),
      ),
    );

    if (!showText) return iconWidget;

    final Widget textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isHorizontal
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // Brand name
        Text(
          'ORGANOVA',
          style: GoogleFonts.poppins(
            fontSize: iconSize * 0.40,
            fontWeight: FontWeight.w800,
            letterSpacing: iconSize * 0.03,
            color: effectiveTextColor,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 1),
        // Tagline
        Text(
          'Simulasi Organisasi & AI',
          style: GoogleFonts.poppins(
            fontSize: iconSize * 0.195,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: effectiveTextColor.withOpacity(0.6),
            height: 1.2,
          ),
        ),
      ],
    );

    if (isHorizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget,
          SizedBox(width: iconSize * 0.22),
          textWidget,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconWidget,
        SizedBox(height: iconSize * 0.22),
        textWidget,
      ],
    );
  }
}

/// ─────────────────────────────────────────────
/// OrganovaLogoWhite — White variant for dark backgrounds
/// ─────────────────────────────────────────────
class OrganovaLogoWhite extends StatelessWidget {
  final double iconSize;
  final bool showText;
  final bool isHorizontal;

  const OrganovaLogoWhite({
    super.key,
    this.iconSize = 48.0,
    this.showText = true,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return OrganovaLogo(
      iconSize: iconSize,
      showText: showText,
      isHorizontal: isHorizontal,
      textColor: Colors.white,
    );
  }
}
