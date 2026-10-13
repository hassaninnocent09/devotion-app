import 'package:flutter_test/flutter_test.dart';
import 'package:devotion_app/utils/format.dart';

void main() {
  test('formats a time label', () {
    expect(timeLabel(8, 0), '8:00 AM');
    expect(timeLabel(0, 5), '12:05 AM');
    expect(timeLabel(13, 30), '1:30 PM');
  });
}
