import '../../models/reading_plan.dart';

List<PlanDay> _days(List<String> refs) =>
    [for (var i = 0; i < refs.length; i++) PlanDay(i + 1, refs[i])];

class MockPlans {
  MockPlans._();

  static final List<ReadingPlan> all = [
    ReadingPlan(
      id: 'john',
      title: 'The Gospel of John',
      description: 'Discover who Jesus is and what His life means for you.',
      minutesPerDay: 5,
      thumb: 'th_sunset',
      days: _days([
        'John 1:1–18', 'John 1:19–51', 'John 2:1–11', 'John 3:16–21', 'John 4:1–26',
        'John 4:27–54', 'John 5:1–24', 'John 6:1–21', 'John 6:22–40', 'John 8:12–30',
        'John 9:1–25', 'John 10:1–18', 'John 11:1–27', 'John 11:28–44', 'John 12:20–36',
        'John 13:1–17', 'John 14:1–14', 'John 15:1–17', 'John 17:1–19', 'John 19:16–30',
        'John 20:1–18',
      ]),
    ),
    ReadingPlan(
      id: 'psalms',
      title: 'Psalms for Everyday Life',
      description: 'Find comfort, courage and praise in the Psalms for the ups and downs of every day.',
      minutesPerDay: 5,
      thumb: 'th_lake',
      days: _days([
        'Psalm 1', 'Psalm 8', 'Psalm 19', 'Psalm 23', 'Psalm 27', 'Psalm 34', 'Psalm 46',
        'Psalm 51', 'Psalm 62', 'Psalm 91', 'Psalm 100', 'Psalm 121', 'Psalm 139', 'Psalm 150',
      ]),
    ),
    ReadingPlan(
      id: 'foundation',
      title: 'Building a Strong Foundation',
      description: 'Build a strong spiritual foundation with thirty days across the whole of Scripture.',
      minutesPerDay: 10,
      thumb: 'th_valley',
      days: _days([
        'Genesis 1:26–31', 'Genesis 3:1–15', 'Exodus 20:1–17', 'Joshua 1:1–9',
        'Psalm 119:9–16', 'Proverbs 3:1–12', 'Isaiah 40:25–31', 'Isaiah 53:1–6',
        'Jeremiah 29:10–14', 'Matthew 5:1–12', 'Matthew 6:5–15', 'Matthew 6:25–34',
        'Matthew 7:24–29', 'Mark 12:28–34', 'Luke 10:25–37', 'Luke 15:11–32',
        'John 3:1–21', 'John 14:15–27', 'Acts 2:36–47', 'Romans 3:21–26', 'Romans 5:1–11',
        'Romans 8:28–39', 'Romans 12:1–8', '1 Corinthians 13:1–13', 'Galatians 5:16–26',
        'Ephesians 2:1–10', 'Ephesians 6:10–18', 'Philippians 4:4–9', 'Colossians 3:12–17',
        'Hebrews 11:1–12',
      ]),
    ),
    ReadingPlan(
      id: 'action',
      title: 'Faith in Action',
      description: 'Learn what it looks like to live out your faith through love, service and perseverance.',
      minutesPerDay: 5,
      thumb: 'th_person',
      days: _days([
        'James 1:2–8', 'James 1:19–27', 'James 2:14–26', 'James 3:1–12', 'James 4:1–10',
        'James 5:13–18', 'Matthew 25:31–46', 'Luke 6:27–38', 'Luke 10:38–42',
        '1 John 3:16–24', '1 Peter 4:7–11', 'Galatians 6:1–10', 'Romans 12:9–21',
        'Micah 6:6–8',
      ]),
    ),
  ];
}
