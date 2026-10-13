class Devotional {
  const Devotional({
    required this.id,
    required this.title,
    required this.reference,
    required this.scripture,
    required this.paragraphs,
    this.minutes = 5,
  });

  final String id;
  final String title;
  final String reference;
  final String scripture;
  final List<String> paragraphs;
  final int minutes;
}
