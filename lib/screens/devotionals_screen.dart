import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'devotional_reading_screen.dart';

/// Devotionals hub (Today / All).
class DevotionalsScreen extends StatefulWidget {
  const DevotionalsScreen({super.key});

  @override
  State<DevotionalsScreen> createState() => _DevotionalsScreenState();
}

class _DevotionalsScreenState extends State<DevotionalsScreen> {
  int _tab = 0;

  List<WeekItem> _week(AppState s) {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    return [
      for (var i = 0; i < 7; i++)
        () {
          final done = s.dayHasCompletion(monday.add(Duration(days: i)));
          return WeekItem(weekdayShort[i], done ? DotState.done : DotState.off, bold: done);
        }(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final today = s.todayDevotional;
    final series = s.series;

    return Scaffold(
      body: GlassPage(
        title: 'Devotionals',
        showBack: true,
        bottomPadding: Insets.bottom(context) + 32,
        children: [
          FadeSlideIn(
            index: 1,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(series.title, style: AppText.serif(22, w: FontWeight.w500, lh: 28)),
                  const SizedBox(height: 6),
                  Text(series.description,
                      style: AppText.t(13, color: AppColors.muted, lh: 20),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: AnimatedBar(s.completedCount / series.totalDays)),
                      const SizedBox(width: 12),
                      Text('${s.completedCount}/${series.totalDays}',
                          style: AppText.t(13, w: FontWeight.w500, color: AppColors.muted)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeSlideIn(
            index: 2,
            child: AppSegmented(
              labels: const ['Today', 'All days'],
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: _tab == 0
                ? Column(
                    key: const ValueKey('today'),
                    children: [
                      HeroCard(
                        height: 360,
                        eyebrow: 'Day ${today.day} of ${series.totalDays}',
                        title: today.title,
                        meta: '${today.category} · ${today.minutes} min read',
                        completed: s.isDoneToday(today),
                        onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: today)),
                        onLibrary: () => setState(() => _tab = 1),
                      ),
                      SectionLabel(
                        'This week',
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 14),
                        trailing: s.streak > 0
                            ? Row(
                                children: [
                                  const AppIcon('fire', size: 18, color: Color(0xFFC9892B), filled: true),
                                  const SizedBox(width: 4),
                                  Text('${s.streak} day streak',
                                      style: AppText.t(13, w: FontWeight.w500, color: AppColors.muted)),
                                ],
                              )
                            : null,
                      ),
                      AppCard(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 16),
                        child: WeekDots(items: _week(s)),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('all'),
                    children: [
                      for (var i = 0; i < s.devotionals.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FadeSlideIn(
                            index: i,
                            child: _DayCard(devotional: s.devotionals[i], done: s.isDoneEver(s.devotionals[i])),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.devotional, required this.done});
  final Devotional devotional;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final d = devotional;
    return AppCard(
      onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: d)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: done ? AppColors.green : const Color(0x1F355539),
              borderRadius: BorderRadius.circular(16),
            ),
            child: done
                ? const AppIcon('check', size: 26, color: Colors.white)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('DAY', style: AppText.t(11, w: FontWeight.w600, color: AppColors.green2, ls: 0.6)),
                      Text('${d.day}', style: AppText.t(17, w: FontWeight.w600, color: AppColors.green)),
                    ],
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.t(15, w: FontWeight.w600, lh: 20)),
                const SizedBox(height: 4),
                Text('${d.category} · ${d.reference}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.t(13, color: AppColors.muted)),
              ],
            ),
          ),
          const AppIcon('right', size: 22, color: AppColors.faint),
        ],
      ),
    );
  }
}
