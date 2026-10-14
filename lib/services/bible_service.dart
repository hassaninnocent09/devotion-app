import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/bible_books.dart';
import '../models/bible.dart';

class BibleUnavailable implements Exception {
  const BibleUnavailable();
}

/// Offline King James Version bundled in assets/data/kjv.json
/// (public domain). Structure: [book][chapter][verse] -> text, in canon order.
class BibleService {
  List<dynamic>? _data;
  Future<void>? _loading;

  Future<void> ensureLoaded() {
    if (_data != null) return Future.value();
    return _loading ??= () async {
      final raw = await rootBundle.loadString('assets/data/kjv.json');
      _data = jsonDecode(raw) as List<dynamic>;
    }();
  }

  Future<List<Verse>> getChapter(Book book, int chapter) async {
    try {
      await ensureLoaded();
      final bookIndex = BibleBooks.all.indexOf(book);
      final chapters = _data![bookIndex] as List<dynamic>;
      final verses = chapters[chapter - 1] as List<dynamic>;
      return [for (var i = 0; i < verses.length; i++) Verse(i + 1, verses[i] as String)];
    } catch (_) {
      _loading = null;
      throw const BibleUnavailable();
    }
  }
}
