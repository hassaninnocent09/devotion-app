class PlanDay {
  const PlanDay(this.day, this.reference);
  final int day;
  final String reference;
}

class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.minutesPerDay,
    required this.thumb,
    required this.days,
  });

  final String id;
  final String title;
  final String description;
  final int minutesPerDay;
  final String thumb;
  final List<PlanDay> days;

  int get totalDays => days.length;
  String get summary => '$totalDays days · $minutesPerDay min/day';
}
