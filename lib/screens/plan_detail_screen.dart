import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';
import 'plan_progress_screen.dart';

/// Reading plan detail.
class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, required this.plan});
  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final started = s.isStarted(plan);
    final preview = plan.days.take(5).toList();

    return Scaffold(
      body: GlassPage(
        title: plan.title,
        largeTitle: false,
        showBack: true,
        bottomPadding: 120 + Insets.bottom(context),
        bottomBar: SizedBox(
          height: 96 + Insets.bottom(context),
          child: Stack(
            children: [
              const Positioned.fill(child: GlassBackdrop(borderTop: true)),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + Insets.bottom(context)),
                child: PrimaryButton(
                  started ? 'Continue Plan' : 'Start Plan',
                  onTap: () {
                    if (!started) s.startPlan(plan);
                    AppNav.replace(context, PlanProgressScreen(plan: plan));
                  },
                ),
              ),
            ],
          ),
        ),
        children: [
          FadeSlideIn(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: const SizedBox(height: 180, width: double.infinity, child: AppPhoto('plan')),
              ),
            ),
          ),
          FadeSlideIn(
            index: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(plan.title, style: AppText.serif(28, w: FontWeight.w500, lh: 36)),
            ),
          ),
          FadeSlideIn(
            index: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Row(
                children: [
                  const AppIcon('plans', size: 20, color: AppColors.green),
                  const SizedBox(width: 8),
                  Text('${plan.totalDays} days', style: AppText.t(14, w: FontWeight.w500, color: AppColors.inkDim)),
                  const SizedBox(width: 24),
                  const AppIcon('clock', size: 20, color: AppColors.green),
                  const SizedBox(width: 8),
                  Text('${plan.minutesPerDay} min/day',
                      style: AppText.t(14, w: FontWeight.w500, color: AppColors.inkDim)),
                ],
              ),
            ),
          ),
          FadeSlideIn(
            index: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text(plan.description, style: AppText.t(15, color: AppColors.muted, lh: 25)),
            ),
          ),
          const SectionLabel("What you'll read", padding: EdgeInsets.fromLTRB(24, 32, 24, 12)),
          FadeSlideIn(
            index: 4,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < preview.length; i++)
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: i == preview.length - 1
                            ? null
                            : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 56,
                            child: Text('Day ${preview[i].day}',
                                style: AppText.t(13, w: FontWeight.w600, color: AppColors.green2)),
                          ),
                          Text(preview[i].reference, style: AppText.t(15, w: FontWeight.w500)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (plan.totalDays > preview.length)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Text('+ ${plan.totalDays - preview.length} more days',
                  style: AppText.t(13, color: AppColors.muted)),
            ),
        ],
      ),
    );
  }
}
