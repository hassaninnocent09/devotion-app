import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';
import 'plan_detail_screen.dart';
import 'plan_progress_screen.dart';

/// Screen 11 – Reading plans list.
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

    return ListView(
      primary: false,
      padding: EdgeInsets.only(top: Insets.top(context), bottom: AppTabBar.height(context) + 16),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Text('Reading Plans', style: AppText.t(24, w: FontWeight.w700, lh: 28)),
        ),
        const SizedBox(height: 18),
        AppSegmented(
          labels: const ['All Plans', 'My Plans'],
          index: _tab,
          onChanged: (i) => setState(() => _tab = i),
        ),
        const SizedBox(height: 20),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Text('You haven’t started a plan yet.',
                textAlign: TextAlign.center,
                style: AppText.t(13, color: AppColors.muted, lh: 22)),
          )
        else
          for (final p in list) _PlanRow(plan: p),
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
    return InkWell(
      onTap: () => AppNav.push(
        context,
        s.isStarted(plan) ? PlanProgressScreen(plan: plan) : PlanDetailScreen(plan: plan),
      ),
      child: Container(
        height: 97,
        padding: const EdgeInsets.only(left: 28, right: 24),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(width: 68, height: 68, child: AppPhoto(plan.thumb)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.title, style: AppText.t(14, w: FontWeight.w600, lh: 19)),
                  const SizedBox(height: 11),
                  Text(plan.summary, style: AppText.t(13, color: AppColors.muted, lh: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
