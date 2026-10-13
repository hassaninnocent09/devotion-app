import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/mock/bible_offline.dart';
import '../models/bible.dart';

class BibleUnavailable implements Exception {
  const BibleUnavailable();
}

/// Loads a chapter. Tries the public-domain World English Bible API first and
/// falls back to a tiny bundled sample. Swap `_translation` or this whole class
/// to plug in a different source.
class BibleService {
  BibleService({http.Client? client}) : _client = client ?? http.Client();

  static const _translation = 'web';
  final http.Client _client;
  final Map<String, List<Verse>> _cache = {};

  Future<List<Verse>> getChapter(Book book, int chapter) async {
    final key = '${book.name} $chapter';
    final cached = _cache[key];
    if (cached != null) return cached;

    try {
      final uri = Uri.https(
        'bible-api.com',
        '/${book.apiName} $chapter',
        {'translation': _translation},
      );
      final res = await _client.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final list = (json['verses'] as List? ?? const [])
            .map((v) => Verse(
                  v['verse'] as int,
                  (v['text'] as String).replaceAll(RegExp(r'\s*\n\s*'), ' ').trim(),
                ))
            .toList();
        if (list.isNotEmpty) {
          _cache[key] = list;
          return list;
        }
      }
    } catch (_) {
      // fall through to offline sample
    }

    final offline = BibleOffline.chapter(book.name, chapter);
    if (offline != null) return offline;
    throw const BibleUnavailable();
  }
}
