import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/reader_screen.dart';

/// Central place for pushing screens so every flow opens them the same way.
class AppNav {
  AppNav._();

  static Future<T?> push<T>(BuildContext context, Widget page) =>
      Navigator.of(context).push<T>(MaterialPageRoute<T>(builder: (_) => page));

  static Future<T?> replace<T>(BuildContext context, Widget page) =>
      Navigator.of(context).pushReplacement<T, void>(MaterialPageRoute<T>(builder: (_) => page));

  static Future<void> openReader(
    BuildContext context,
    Book book,
    int chapter, {
    int? startVerse,
    int? endVerse,
    String? planId,
    int? planDay,
  }) {
    return push(
      context,
      ReaderScreen(
        book: book,
        chapter: chapter,
        startVerse: startVerse,
        endVerse: endVerse,
        planId: planId,
        planDay: planDay,
      ),
    );
  }

  /// Back to the tab shell, optionally selecting a tab.
  static void popToRoot(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);
}
