import 'package:flutter/widgets.dart';

/// Real device insets (notch / status bar / gesture bar) — no hard-coded padding.
class Insets {
  Insets._();
  static double top(BuildContext c) => MediaQuery.paddingOf(c).top;
  static double bottom(BuildContext c) => MediaQuery.paddingOf(c).bottom;

  /// Standard horizontal page margin.
  static const double page = 20;
}
