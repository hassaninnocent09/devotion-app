import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Type system. Only three weights are used: 400, 500, 600.
/// `size` values are the design's nominal sizes; they are scaled up slightly so
/// small text stays comfortably legible on real devices.
class AppText {
  AppText._();

  static const sans = 'PlusJakartaSans';
  static const serifFamily = 'Lora';

  static double _scale(double s) {
    if (s <= 11) return 12;
    if (s <= 13.5) return s + 1.5; // 13 -> 14.5 (captions, secondary)
    if (s <= 15) return s + 1; // 14 -> 15, 15 -> 16 (body)
    if (s <= 20) return s + 1;
    return s;
  }

  static FontWeight _weight(FontWeight w) {
    if (w.value <= 400) return FontWeight.w400;
    if (w.value <= 500) return FontWeight.w500;
    return FontWeight.w600;
  }

  static TextStyle _make(String family, double size, FontWeight w, Color color,
      double? lh, double? ls) {
    final fs = _scale(size);
    final fw = _weight(w);
    return TextStyle(
      fontFamily: family,
      fontSize: fs,
      fontWeight: fw,
      color: color,
      height: lh == null ? null : (lh / size).clamp(1.15, 2.2).toDouble(),
      leadingDistribution: TextLeadingDistribution.even,
      letterSpacing: ls ?? (fs >= 22 ? -0.3 : 0),
      fontVariations: [FontVariation('wght', fw.value.toDouble())],
    );
  }

  /// Sans (Plus Jakarta Sans).
  static TextStyle t(
    double size, {
    FontWeight w = FontWeight.w400,
    Color color = AppColors.ink,
    double? lh,
    double? ls,
  }) =>
      _make(sans, size, w, color, lh, ls);

  /// Serif (Lora) for display titles, scripture and Bible text.
  static TextStyle serif(
    double size, {
    FontWeight w = FontWeight.w400,
    Color color = AppColors.ink,
    double? lh,
    double? ls,
  }) =>
      _make(serifFamily, size, w, color, lh, ls);
}
