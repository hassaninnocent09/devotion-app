import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// The mockup reserves 44px for the status bar; real devices report their own
/// inset, so use whichever is larger to keep the design's rhythm.
class Insets {
  Insets._();
  static double top(BuildContext c) => math.max(MediaQuery.paddingOf(c).top, 44);
  static double bottom(BuildContext c) => MediaQuery.paddingOf(c).bottom;
}
