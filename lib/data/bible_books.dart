import '../models/bible.dart';

/// The 66 books with chapter counts.
class BibleBooks {
  BibleBooks._();

  static Book _ot(String n, int c, {String? api}) => Book(n, c, oldTestament: true, api: api);
  static Book _nt(String n, int c) => Book(n, c, oldTestament: false);

  static final List<Book> all = [
    _ot('Genesis', 50), _ot('Exodus', 40), _ot('Leviticus', 27), _ot('Numbers', 36),
    _ot('Deuteronomy', 34), _ot('Joshua', 24), _ot('Judges', 21), _ot('Ruth', 4),
    _ot('1 Samuel', 31), _ot('2 Samuel', 24), _ot('1 Kings', 22), _ot('2 Kings', 25),
    _ot('1 Chronicles', 29), _ot('2 Chronicles', 36), _ot('Ezra', 10), _ot('Nehemiah', 13),
    _ot('Esther', 10), _ot('Job', 42), _ot('Psalms', 150, api: 'Psalm'), _ot('Proverbs', 31),
    _ot('Ecclesiastes', 12), _ot('Song of Solomon', 8), _ot('Isaiah', 66), _ot('Jeremiah', 52),
    _ot('Lamentations', 5), _ot('Ezekiel', 48), _ot('Daniel', 12), _ot('Hosea', 14),
    _ot('Joel', 3), _ot('Amos', 9), _ot('Obadiah', 1), _ot('Jonah', 4), _ot('Micah', 7),
    _ot('Nahum', 3), _ot('Habakkuk', 3), _ot('Zephaniah', 3), _ot('Haggai', 2),
    _ot('Zechariah', 14), _ot('Malachi', 4),
    _nt('Matthew', 28), _nt('Mark', 16), _nt('Luke', 24), _nt('John', 21), _nt('Acts', 28),
    _nt('Romans', 16), _nt('1 Corinthians', 16), _nt('2 Corinthians', 13), _nt('Galatians', 6),
    _nt('Ephesians', 6), _nt('Philippians', 4), _nt('Colossians', 4),
    _nt('1 Thessalonians', 5), _nt('2 Thessalonians', 3), _nt('1 Timothy', 6),
    _nt('2 Timothy', 4), _nt('Titus', 3), _nt('Philemon', 1), _nt('Hebrews', 13),
    _nt('James', 5), _nt('1 Peter', 5), _nt('2 Peter', 3), _nt('1 John', 5), _nt('2 John', 1),
    _nt('3 John', 1), _nt('Jude', 1), _nt('Revelation', 22),
  ];

  static const _aliases = {
    'psalm': 'Psalms',
    'song of songs': 'Song of Solomon',
    'revelations': 'Revelation',
  };

  /// Exact (case-insensitive) lookup with a few common aliases.
  static Book? find(String name) {
    var key = name.trim().toLowerCase();
    key = _aliases[key]?.toLowerCase() ?? key;
    for (final b in all) {
      if (b.name.toLowerCase() == key) return b;
    }
    return null;
  }

  static List<Book> testament({required bool old}) =>
      all.where((b) => b.oldTestament == old).toList();
}
