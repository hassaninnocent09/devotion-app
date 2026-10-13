import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'devotional_reading_screen.dart';

/// Screen 8 – Devotionals hub (Today / All).
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
          final day = monday.add(Duration(days: i));
          final done = s.dayHasCompletion(day);
          return WeekItem(weekdayShort[i], done ? DotState.done : DotState.off, bold: done);
        }(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final today = s.todayDevotional;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: Insets.top(context), bottom: Insets.bottom(context) + 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Text('Devotionals', style: AppText.t(24, w: FontWeight.w700, lh: 28)),
          ),
          const SizedBox(height: 30),
          AppSegmented(
            labels: const ['Today', 'All'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 30),
          if (_tab == 0) ...[
            HeroCard(
              height: 314,
              eyebrow: 'DAILY DEVOTIONAL',
              caps: true,
              title: today.title,
              minutes: today.minutes,
              completed: s.isDoneToday(today),
              onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: today)),
              onTarget: () => setState(() => _tab = 1),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(44, 54, 44, 0),
              child: Text('This Week', style: AppText.t(15, w: FontWeight.w700, lh: 20)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 24, 13, 0),
              child: WeekDots(items: _week(s)),
            ),
          ] else
            for (final d in s.devotionals)
              InkWell(
                onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: d)),
                child: Container(
                  height: 97,
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const SizedBox(width: 68, height: 68, child: AppPhoto('hills')),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.t(14, w: FontWeight.w600, lh: 19)),
                            const SizedBox(height: 8),
                            Text('${d.reference} · ${d.minutes} min read',
                                style: AppText.t(13, color: AppColors.muted, lh: 18)),
                          ],
                        ),
                      ),
                      if (s.isDoneEver(d))
                        const AppIcon('check-circle', size: 22, color: AppColors.green),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
