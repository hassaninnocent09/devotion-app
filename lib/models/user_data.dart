class SavedVerse {
  SavedVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.addedAt,
    this.bookmarked = false,
    this.highlighted = false,
    this.note,
  });

  final String book;
  final int chapter;
  final int verse;
  final String text;
  final DateTime addedAt;
  bool bookmarked;
  bool highlighted;
  String? note;

  String get ref => '$book $chapter:$verse';
  bool get isEmpty => !bookmarked && !highlighted && (note == null || note!.isEmpty);

  Map<String, dynamic> toJson() => {
        'book': book,
        'chapter': chapter,
        'verse': verse,
        'text': text,
        'at': addedAt.toIso8601String(),
        'bookmarked': bookmarked,
        'highlighted': highlighted,
        'note': note,
      };

  factory SavedVerse.fromJson(Map<String, dynamic> j) => SavedVerse(
        book: j['book'] as String,
        chapter: j['chapter'] as int,
        verse: j['verse'] as int,
        text: j['text'] as String,
        addedAt: DateTime.parse(j['at'] as String),
        bookmarked: j['bookmarked'] as bool? ?? false,
        highlighted: j['highlighted'] as bool? ?? false,
        note: j['note'] as String?,
      );
}

class SavedPassage {
  SavedPassage({required this.ref, required this.text, required this.addedAt});
  final String ref;
  final String text;
  final DateTime addedAt;

  Map<String, dynamic> toJson() => {'ref': ref, 'text': text, 'at': addedAt.toIso8601String()};
  factory SavedPassage.fromJson(Map<String, dynamic> j) => SavedPassage(
        ref: j['ref'] as String,
        text: j['text'] as String,
        addedAt: DateTime.parse(j['at'] as String),
      );
}

class Completion {
  const Completion(this.devotionalId, this.dateKey);
  final String devotionalId;
  final String dateKey;

  Map<String, dynamic> toJson() => {'id': devotionalId, 'date': dateKey};
  factory Completion.fromJson(Map<String, dynamic> j) =>
      Completion(j['id'] as String, j['date'] as String);
}

class HistoryEntry {
  const HistoryEntry(this.book, this.chapter, this.at);
  final String book;
  final int chapter;
  final DateTime at;

  Map<String, dynamic> toJson() => {'book': book, 'chapter': chapter, 'at': at.toIso8601String()};
  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
        j['book'] as String,
        j['chapter'] as int,
        DateTime.parse(j['at'] as String),
      );
}

class ReminderSettings {
  const ReminderSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
    required this.days,
  });

  final bool enabled;
  final int hour;
  final int minute;

  /// Monday → Sunday.
  final List<bool> days;

  factory ReminderSettings.defaults() => const ReminderSettings(
        enabled: true,
        hour: 8,
        minute: 0,
        days: [true, true, true, true, true, true, false],
      );

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute, List<bool>? days}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        days: days ?? this.days,
      );

  Map<String, dynamic> toJson() =>
      {'enabled': enabled, 'hour': hour, 'minute': minute, 'days': days};

  factory ReminderSettings.fromJson(Map<String, dynamic> j) => ReminderSettings(
        enabled: j['enabled'] as bool,
        hour: j['hour'] as int,
        minute: j['minute'] as int,
        days: (j['days'] as List).map((e) => e as bool).toList(),
      );
}
