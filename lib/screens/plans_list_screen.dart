import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'plan_detail_screen.dart';
import 'plan_progress_screen.dart';

/// Reading plans list.
class PlansListScreen extends StatefulWidget {
  const PlansListScreen({super.key});

  @override
  State<PlansListScreen> createState() => _PlansListScreenState();
}

class _PlansListScreenState extends State<PlansListScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final list = _tab == 0 ? s.plans : s.myPlans;

    return GlassPage(
      title: 'Reading Plans',
      bottomPadding: AppTabBar.height(context) + 28,
      children: [
        FadeSlideIn(
          index: 1,
          child: AppSegmented(
            labels: const ['All Plans', 'My Plans'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: Column(
            key: ValueKey(_tab),
            children: [
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 48, 40, 0),
                  child: Column(
                    children: [
                      const IconTile('plans', size: 64),
                      const SizedBox(height: 20),
                      Text('You haven’t started a plan yet.',
                          textAlign: TextAlign.center,
                          style: AppText.t(14, color: AppColors.muted, lh: 22)),
                    ],
                  ),
                )
              else
                for (var i = 0; i < list.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FadeSlideIn(index: i, child: _PlanRow(plan: list[i])),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.plan});
  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final started = s.isStarted(plan);
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () => AppNav.push(
        context,
        started ? PlanProgressScreen(plan: plan) : PlanDetailScreen(plan: plan),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(width: 76, height: 76, child: AppPhoto(plan.thumb)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.t(15, w: FontWeight.w600, lh: 20)),
                const SizedBox(height: 4),
                Text(plan.summary, style: AppText.t(13, color: AppColors.muted)),
                if (started) ...[
                  const SizedBox(height: 10),
                  AnimatedBar(s.progress(plan), height: 5),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const AppIcon('right', size: 22, color: AppColors.faint),
        ],
      ),
    );
  }
}
