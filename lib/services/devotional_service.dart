import '../data/mock/devotionals.dart';
import '../models/devotional.dart';

/// Mock-backed; replace the body with an API call later.
class DevotionalService {
  Future<List<Devotional>> all() async => MockDevotionals.all;
}
