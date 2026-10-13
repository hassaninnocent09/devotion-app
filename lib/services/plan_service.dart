import '../data/mock/plans.dart';
import '../models/reading_plan.dart';

/// Mock-backed; replace the body with an API call later.
class PlanService {
  Future<List<ReadingPlan>> all() async => MockPlans.all;
}
