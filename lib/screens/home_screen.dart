import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'devotional_reading_screen.dart';
import 'devotionals_screen.dart';
import 'plan_progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final now = DateTime.now();
    final dev = s.todayDevotional;
    final plan = s.activePlan;

    return ListView(
      primary: false,
      padding: EdgeInsets.only(
        top: Insets.top(context),
        bottom: AppTabBar.height(context) + 24,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 34),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text('${greeting(now)},',
                        style: AppText.t(13, color: AppColors.inkDim, lh: 18)),
                    const SizedBox(height: 7),
                    Text(s.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.t(26, w: FontWeight.w500, lh: 30)),
                    const SizedBox(height: 19),
                    Text(fullDate(now), style: AppText.t(13, color: AppColors.muted, lh: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: GestureDetector(
                  onTap: () => s.setTab(3),
                  child: const AppAvatar(size: 40),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        HeroCard(
          height: 302,
          eyebrow: "Today's Devotional",
          title: dev.title,
          minutes: dev.minutes,
          completed: false,
          onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: dev)),
          onTarget: () => AppNav.push(context, const DevotionalsScreen()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(44, 36, 44, 0),
          child: Text('Reading Plan Progress', style: AppText.t(14, w: FontWeight.w700, lh: 19)),
        ),
        const SizedBox(height: 8),
        _PlanCard(plan: plan),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});
  final ReadingPlan? plan;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final p = plan;
    final Widget content;
    VoidCallback? onTap;

    if (p == null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start a reading plan', style: AppText.t(13, w: FontWeight.w600, lh: 18)),
          const SizedBox(height: 13),
          Text('Pick a plan to track your progress here.',
              style: AppText.t(13, color: AppColors.muted, lh: 18)),
        ],
      );
      onTap = () => s.setTab(2);
    } else {
      final done = s.doneCount(p);
      final pct = (s.progress(p) * 100).round();
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.title, style: AppText.t(13, w: FontWeight.w600, lh: 18)),
          const SizedBox(height: 13),
          Text('$done / ${p.totalDays} days',
              style: AppText.t(13, color: AppColors.muted, lh: 18)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: s.progress(p),
                    minHeight: 6,
                    backgroundColor: AppColors.track,
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('$pct%', style: AppText.t(13, color: AppColors.muted)),
            ],
          ),
        ],
      );
      onTap = () => AppNav.push(context, PlanProgressScreen(plan: p));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 110),
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

