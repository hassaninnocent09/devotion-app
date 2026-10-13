import '../data/bible_books.dart';
import '../models/bible.dart';

/// A parsed reference such as "John 4:1–26", "Psalm 23" or "Romans 8:1".
class PassageRef {
  PassageRef(this.book, this.chapter, {this.start, this.end});

  final Book book;
  final int chapter;
  final int? start;
  final int? end;

  static final _re = RegExp(r'^(.+?)\s+(\d+)(?::(\d+)(?:\s*[–-]\s*(\d+))?)?$');

  static PassageRef? parse(String ref) {
    final m = _re.firstMatch(ref.trim());
    if (m == null) return null;
    final book = BibleBooks.find(m.group(1)!);
    if (book == null) return null;
    final chapter = int.parse(m.group(2)!);
    if (chapter < 1 || chapter > book.chapters) return null;
    final s = m.group(3);
    final e = m.group(4);
    return PassageRef(
      book,
      chapter,
      start: s == null ? null : int.parse(s),
      end: e == null ? null : int.parse(e),
    );
  }
}
