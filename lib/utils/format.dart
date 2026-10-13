const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];
const weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December'
];

String _two(int n) => n.toString().padLeft(2, '0');

/// "Monday, 12 October"
String fullDate(DateTime d) => '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';

/// "12 Oct 2026"
String shortDate(DateTime d) => '${d.day} ${_months[d.month - 1].substring(0, 3)} ${d.year}';

/// "2026-10-12"
String dateKey(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

/// "8:00 AM"
String timeLabel(int hour, int minute) {
  final h = hour % 12 == 0 ? 12 : hour % 12;
  final ap = hour < 12 ? 'AM' : 'PM';
  return '$h:${_two(minute)} $ap';
}

String greeting(DateTime d) {
  if (d.hour < 12) return 'Good morning';
  if (d.hour < 18) return 'Good afternoon';
  return 'Good evening';
}
