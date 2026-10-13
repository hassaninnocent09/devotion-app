import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'devotional_complete_screen.dart';

/// Screen 9 – Devotional reading.
class DevotionalReadingScreen extends StatelessWidget {
  const DevotionalReadingScreen({super.key, required this.devotional});
  final Devotional devotional;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final d = devotional;
    final top = Insets.top(context);
    final isToday = d.id == s.todayDevotional.id;
    final done = s.isDoneToday(d);
    final saved = s.isPassageSaved(d.reference);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: top + 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const AppPhoto('hills'),
                  Positioned(
                    left: 22,
                    top: top + 18,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0x8CFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: const AppIcon('left', size: 15, color: Color(0xFF4A463B)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 22,
                    top: top + 18,
                    child: GestureDetector(
                      onTap: () {
                        final on = s.togglePassage(d);
                        showToast(context, on ? 'Passage saved' : 'Passage removed');
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xEBFFFFFF),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: AppIcon('bookmark',
                            size: 15, filled: saved, color: const Color(0xFF4A463B)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
              child: Text('DAILY DEVOTIONAL',
                  style: AppText.t(13,
                      w: FontWeight.w700, color: AppColors.inkDim, lh: 18, ls: 1.04)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 14, 28, 0),
              child: Text(d.title, style: AppText.t(24, w: FontWeight.w700, lh: 36)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 11, 28, 0),
              child: Text(
                isToday
                    ? '${fullDate(DateTime.now())} · ${d.minutes} min read'
                    : '${d.minutes} min read',
                style: AppText.t(13, color: AppColors.muted, lh: 18),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(22, 41, 22, 0),
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scripture', style: AppText.t(13, color: AppColors.muted, lh: 18)),
                  const SizedBox(height: 17),
                  Text(d.reference, style: AppText.t(15, w: FontWeight.w700, lh: 20)),
                  const SizedBox(height: 9),
                  Text('“${d.scripture}”',
                      style: AppText.t(14, color: AppColors.inkDim, lh: 28)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
              child: Text('Reflection', style: AppText.t(17, w: FontWeight.w700, lh: 22)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < d.paragraphs.length; i++)
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
                      child: Text(d.paragraphs[i],
                          style: AppText.t(13.5, color: AppColors.inkDim, lh: 27)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(26, 36, 26, math.max(32.0, Insets.bottom(context) + 20)),
              child: PrimaryButton(
                done ? 'Completed' : 'Mark as complete',
                onTap: () {
                  if (!done) s.completeDevotional(d);
                  AppNav.push(context, DevotionalCompleteScreen(devotional: d));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
