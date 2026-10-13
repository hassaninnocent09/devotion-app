import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text style factory. `lh` is a CSS-style line-height in logical px.
class AppText {
  AppText._();

  static const family = 'PlusJakartaSans';

  static TextStyle t(
    double size, {
    FontWeight w = FontWeight.w400,
    Color color = AppColors.ink,
    double? lh,
    double? ls,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: w,
      color: color,
      height: lh == null ? null : lh / size,
      leadingDistribution: TextLeadingDistribution.even,
      letterSpacing: ls,
    );
  }
}
