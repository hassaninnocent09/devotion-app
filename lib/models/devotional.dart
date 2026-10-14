class Devotional {
  const Devotional({
    required this.id,
    required this.day,
    required this.title,
    required this.subtitle,
    required this.reference,
    required this.translation,
    required this.keyVerse,
    required this.body,
    required this.questions,
    required this.prayer,
    required this.action,
    required this.category,
    required this.minutes,
  });

  final String id;
  final int day;
  final String title;
  final String subtitle;
  final String reference;
  final String translation;
  final String keyVerse;
  final String body;
  final List<String> questions;
  final String prayer;
  final String action;
  final String category;
  final int minutes;

  factory Devotional.fromJson(Map<String, dynamic> j) {
    final s = j['scripture'] as Map<String, dynamic>;
    return Devotional(
      id: 'day${j['day']}',
      day: j['day'] as int,
      title: j['title'] as String,
      subtitle: j['subtitle'] as String? ?? '',
      reference: s['reference'] as String,
      translation: s['translation'] as String? ?? 'KJV',
      keyVerse: s['key_verse'] as String,
      body: j['devotional'] as String,
      questions: (j['reflection_questions'] as List).map((e) => e as String).toList(),
      prayer: j['prayer'] as String,
      action: j['daily_action'] as String,
      category: j['category'] as String? ?? '',
      minutes: j['reading_time_minutes'] as int? ?? 4,
    );
  }

  /// The body split into short paragraphs (about three sentences each).
  List<String> get paragraphs {
    final sentences = body.split(RegExp(r'(?<=[.!?])\s+'));
    final out = <String>[];
    for (var i = 0; i < sentences.length; i += 3) {
      out.add(sentences.skip(i).take(3).join(' '));
    }
    return out;
  }
}

class DevotionalSeries {
  const DevotionalSeries({
    required this.title,
    required this.description,
    required this.totalDays,
    required this.items,
  });

  final String title;
  final String description;
  final int totalDays;
  final List<Devotional> items;
}
