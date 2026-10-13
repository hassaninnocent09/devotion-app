import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

/// Screen 13 – Plan progress.
class PlanProgressScreen extends StatefulWidget {
  const PlanProgressScreen({super.key, required this.plan});
  final ReadingPlan plan;

  @override
  State<PlanProgressScreen> createState() => _PlanProgressScreenState();
}

class _PlanProgressScreenState extends State<PlanProgressScreen> {
  int _tab = 0;

  void _open(PlanDay d) {
    final r = PassageRef.parse(d.reference);
    if (r == null) return;
    AppNav.openReader(
      context,
      r.book,
      r.chapter,
      startVerse: r.start,
      endVerse: r.end,
      planId: widget.plan.id,
      planDay: d.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final plan = widget.plan;
    final done = s.doneDays(plan);
    final next = s.nextDay(plan);
    final completed = plan.days.where((d) => done.contains(d.day)).toList().reversed.toList();
    final pct = (s.progress(plan) * 100).round();

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(bottom: Insets.bottom(context) + 32),
        children: [
          BackHeader(plan.title),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(size: const Size(72, 72), painter: _RingPainter(s.progress(plan))),
                  Text('$pct%', style: AppText.t(14, w: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('${done.length} / ${plan.totalDays} days',
              textAlign: TextAlign.center,
              style: AppText.t(13, w: FontWeight.w600, color: AppColors.inkDim, lh: 18)),
          UnderlineTabs(
            labels: const ['Current', 'Completed'],
            index: _tab,
            height: 46,
            margin: const EdgeInsets.fromLTRB(26, 22, 26, 0),
            onChanged: (i) => setState(() => _tab = i),
          ),
          if (_tab == 0) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 28, 26, 0),
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: next == null
                    ? Row(children: [
                        const AppIcon('check-circle', size: 22, color: AppColors.green),
                        const SizedBox(width: 14),
                        Text('Plan complete', style: AppText.t(13, w: FontWeight.w600)),
                      ])
                    : InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _open(next),
                        child: Row(
                          children: [
                            const AppIcon('route', size: 22, color: AppColors.inkDim),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Day ${next.day}',
                                      style: AppText.t(13, w: FontWeight.w600, lh: 18)),
                                  const SizedBox(height: 10),
                                  Text(next.reference,
                                      style: AppText.t(13, color: AppColors.muted, lh: 18)),
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.pillBg,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.pillBorder),
                              ),
                              child: Text('Continue',
                                  style: AppText.t(13, w: FontWeight.w700, color: AppColors.green)),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          for (final d in completed) _DayRow(day: d, onTap: () => _open(d)),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day, required this.onTap});
  final PlanDay day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 78,
        margin: const EdgeInsets.symmetric(horizontal: 26),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
        ),
        child: Row(
          children: [
            const AppIcon('clock', size: 22, color: AppColors.inkDim),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day ${day.day}', style: AppText.t(13, w: FontWeight.w600, lh: 18)),
                  const SizedBox(height: 10),
                  Text(day.reference, style: AppText.t(13, color: AppColors.muted, lh: 18)),
                ],
              ),
            ),
            const AppIcon('check-circle', size: 22, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: 30);
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = AppColors.ringTrack;
    canvas.drawCircle(rect.center, 30, bg);
    if (value <= 0) return;
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = AppColors.green;
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * value.clamp(0.0, 1.0), false, fg);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}
