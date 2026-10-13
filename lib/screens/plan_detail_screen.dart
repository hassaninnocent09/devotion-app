import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';
import 'plan_progress_screen.dart';

/// Screen 12 – Reading plan detail.
class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, required this.plan});
  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final started = s.isStarted(plan);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: Insets.top(context), bottom: Insets.bottom(context) + 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 26, right: 26),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(34, 3, 6, 12),
                      child: AppIcon('left', size: 18),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const SizedBox(height: 126, child: AppPhoto('plan')),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 0),
              child: Text(plan.title, style: AppText.t(20, w: FontWeight.w700, lh: 24)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 15, 26, 0),
              child: Text(plan.summary, style: AppText.t(13, color: AppColors.muted, lh: 18)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 21, 26, 0),
              child: Text(plan.description, style: AppText.t(14, color: AppColors.muted, lh: 28)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 22, 26, 0),
              child: PrimaryButton(
                started ? 'Continue Plan' : 'Start Plan',
                height: 48,
                onTap: () {
                  if (!started) s.startPlan(plan);
                  AppNav.replace(context, PlanProgressScreen(plan: plan));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 45, 26, 0),
              child: Text('Plan Overview', style: AppText.t(15, w: FontWeight.w700, lh: 20)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 0),
              child: Row(
                children: [
                  const AppIcon('plans', size: 18, color: AppColors.inkDim),
                  const SizedBox(width: 10),
                  Text('${plan.totalDays} days', style: AppText.t(13, color: AppColors.inkDim, lh: 18)),
                  const SizedBox(width: 40),
                  const AppIcon('clock', size: 18, color: AppColors.inkDim),
                  const SizedBox(width: 10),
                  Text('${plan.minutesPerDay} min/day',
                      style: AppText.t(13, color: AppColors.inkDim, lh: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
