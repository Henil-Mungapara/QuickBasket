import 'package:flutter/material.dart';

/// App-wide color constants — Fresh Grocery Theme
class AppColors {
  AppColors._(); // prevent instantiation

  // ── Primary palette ──────────────────────────────────────────────
  static const Color primary = Color(0xFF2ECC71);       // Fresh Green
  static const Color secondary = Color(0xFF27AE60);     // Leaf Green
  static const Color accent = Color(0xFFF1C40F);        // Yellow

  // ── Backgrounds ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F7F7);   // Light Gray
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF7F7F7);

  // ── Text ─────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2C3E50);   // Dark Gray
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Colors.white;

  // ── Utility ──────────────────────────────────────────────────────
  static const Color error = Color(0xFFE74C3C);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color divider = Color(0xFFECECEC);
  static const Color shadow = Color(0x1A000000);

  // ── Status colors for orders ─────────────────────────────────────
  static const Color pending = Color(0xFFF39C12);
  static const Color accepted = Color(0xFF3498DB);
  static const Color outForDelivery = Color(0xFF8E44AD);
  static const Color delivered = Color(0xFF2ECC71);
}
