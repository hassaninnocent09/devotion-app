import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

/// Plan progress.
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
    final upcoming = plan.days.where((d) => !done.contains(d.day) && d.day != next?.day).toList();
    final shown = _tab == 0 ? upcoming.take(6).toList() : completed;
    final pct = (s.progress(plan) * 100).round();

    return Scaffold(
      body: GlassPage(
        title: plan.title,
        largeTitle: false,
        showBack: true,
        bottomPadding: Insets.bottom(context) + 32,
        children: [
          FadeSlideIn(
            child: Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  width: 112,
                  height: 112,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: s.progress(plan)),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, __) => Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(size: const Size(112, 112), painter: _RingPainter(v)),
                        Text('$pct%', style: AppText.t(22, w: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(plan.title, style: AppText.serif(22, w: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('${done.length} of ${plan.totalDays} days',
                    style: AppText.t(14, w: FontWeight.w500, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          if (next != null)
            FadeSlideIn(
              index: 1,
              child: Pressable(
                onTap: () => _open(next),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3A5E40), Color(0xFF2B4630)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Color(0x40355539), blurRadius: 24, offset: Offset(0, 12))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('UP NEXT · DAY ${next.day}',
                                style: AppText.t(11, w: FontWeight.w600, color: const Color(0xB3FFFFFF), ls: 1)),
                            const SizedBox(height: 8),
                            Text(next.reference, style: AppText.serif(24, w: FontWeight.w500, color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Color(0xFFF9F5EC), shape: BoxShape.circle),
                        child: const AppIcon('forward', size: 24, color: AppColors.green),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            FadeSlideIn(
              index: 1,
              child: AppCard(
                child: Row(
                  children: [
                    const IconTile('check-circle', size: 44, filled: true),
                    const SizedBox(width: 14),
                    Text('Plan complete. Well done!', style: AppText.t(15, w: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          AppSegmented(
            labels: const ['Upcoming', 'Completed'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: Column(
              key: ValueKey(_tab),
              children: [
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(_tab == 0 ? 'Nothing else upcoming.' : 'No days completed yet.',
                        style: AppText.t(14, color: AppColors.muted)),
                  )
                else
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < shown.length; i++)
                          Pressable(
                            scale: 0.99,
                            onTap: () => _open(shown[i]),
                            child: Container(
                              height: 68,
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                border: i == shown.length - 1
                                    ? null
                                    : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
                              ),
                              child: Row(
                                children: [
                                  AppIcon(done.contains(shown[i].day) ? 'check-circle' : 'clock',
                                      size: 24,
                                      filled: done.contains(shown[i].day),
                                      color: done.contains(shown[i].day) ? AppColors.green : AppColors.muted),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Day ${shown[i].day}', style: AppText.t(15, w: FontWeight.w600)),
                                        const SizedBox(height: 2),
                                        Text(shown[i].reference,
                                            style: AppText.t(13, color: AppColors.muted)),
                                      ],
                                    ),
                                  ),
                                  const AppIcon('right', size: 22, color: AppColors.faint),
                                ],
                              ),
                            ),
                          ),
                      ],
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

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 7;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);
    canvas.drawCircle(
      rect.center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..color = AppColors.ringTrack,
    );
    if (value <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * value.clamp(0.0, 1.0).toDouble(),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..color = AppColors.green,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}
