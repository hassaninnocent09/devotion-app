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

    return GlassPage(
      largeTitle: false,
      bottomPadding: AppTabBar.height(context) + 28,
      children: [
        FadeSlideIn(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${greeting(now)},', style: AppText.t(14, color: AppColors.inkDim)),
                      const SizedBox(height: 2),
                      Text(s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.serif(32, w: FontWeight.w500, lh: 40)),
                      const SizedBox(height: 4),
                      Text(fullDate(now), style: AppText.t(13, color: AppColors.muted)),
                    ],
                  ),
                ),
                Pressable(
                  onTap: () => s.setTab(3),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: const AppAvatar(size: 48),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FadeSlideIn(
          index: 1,
          child: HeroCard(
            height: 360,
            eyebrow: s.isDoneToday(dev) ? 'Today’s devotional' : 'Day ${dev.day} of ${s.series.totalDays}',
            title: dev.title,
            meta: '${dev.category} · ${dev.minutes} min read',
            completed: s.isDoneToday(dev),
            onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: dev)),
            onLibrary: () => AppNav.push(context, const DevotionalsScreen()),
          ),
        ),
        FadeSlideIn(
          index: 2,
          child: SectionLabel(
            'Your progress',
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 14),
          ),
        ),
        FadeSlideIn(
          index: 3,
          child: _ProgressCard(
            icon: 'library',
            title: s.series.title,
            subtitle: '${s.completedCount} of ${s.series.totalDays} days',
            value: s.completedCount / s.series.totalDays,
            onTap: () => AppNav.push(context, const DevotionalsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        FadeSlideIn(
          index: 4,
          child: plan == null
              ? _ProgressCard(
                  icon: 'plans',
                  title: 'Start a reading plan',
                  subtitle: 'Pick a plan to track it here',
                  value: null,
                  onTap: () => s.setTab(2),
                )
              : _ProgressCard(
                  icon: 'book',
                  title: plan.title,
                  subtitle: '${s.doneCount(plan)} of ${plan.totalDays} days',
                  value: s.progress(plan),
                  onTap: () => AppNav.push(context, PlanProgressScreen(plan: plan)),
                ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final double? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.t(15, w: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(subtitle, style: AppText.t(13, color: AppColors.muted)),
                if (value != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: AnimatedBar(value!)),
                      const SizedBox(width: 12),
                      Text('${(value! * 100).round()}%',
                          style: AppText.t(13, w: FontWeight.w500, color: AppColors.muted)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (value == null) const AppIcon('right', size: 22, color: AppColors.faint),
        ],
      ),
    );
  }
}
