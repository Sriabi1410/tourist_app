import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─── Primary Surfaces ─────────────────────────────────────────────────
  static const Color bgDark       = Color(0xFF0B0F1A);
  static const Color bgCard       = Color(0xFF131829);
  static const Color bgElevated   = Color(0xFF1A2035);
  static const Color bgSurface    = Color(0xFF212840);

  // ─── Accent Colors ────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF6C63FF);   // Indigo violet
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark  = Color(0xFF4F46E5);
  static const Color secondary    = Color(0xFF00D9A6);   // Mint teal
  static const Color secondaryLight = Color(0xFF34EDBE);
  static const Color accent       = Color(0xFFFF6B6B);   // Coral
  static const Color accentWarm   = Color(0xFFFFAA5C);   // Amber
  static const Color info         = Color(0xFF38BDF8);   // Sky blue

  // ─── SOS / Emergency ──────────────────────────────────────────────────
  static const Color sosRed       = Color(0xFFFF3B5C);
  static const Color sosRedDark   = Color(0xFFCC2244);
  static const Color sosGlow      = Color(0x40FF3B5C);
  static const Color warning      = Color(0xFFFFB547);
  static const Color success      = Color(0xFF10B981);
  static const Color danger       = Color(0xFFEF4444);

  // ─── Text ─────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFB0B8CC);
  static const Color textMuted     = Color(0xFF6B7280);
  static const Color textDisabled  = Color(0xFF4B5563);

  // ─── Glass / Overlay ──────────────────────────────────────────────────
  static const Color glassFill     = Color(0x0FFFFFFF);
  static const Color glassBorder   = Color(0x1AFFFFFF);
  static const Color glassHighlight= Color(0x33FFFFFF);
  static const Color overlay       = Color(0x80000000);

  // ─── Gradients ────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D9A6), Color(0xFF00B894)],
  );

  static const LinearGradient sosGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF3B5C), Color(0xFFCC2244)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF131829), Color(0xFF0B0F1A)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x14FFFFFF), Color(0x05FFFFFF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFFAA5C)],
  );
}
