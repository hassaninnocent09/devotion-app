import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'devotional_reading_screen.dart';

class CompletedDevotionalsScreen extends StatelessWidget {
  const CompletedDevotionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final rows = <Widget>[];
    for (final c in s.completedDevotionals) {
      final d = s.devotionalById(c.devotionalId);
      if (d == null) continue;
      rows.add(AppCard(
        onTap: () => AppNav.push(context, DevotionalReadingScreen(devotional: d)),
        child: Row(
          children: [
            const IconTile('check-square', size: 44, filled: true),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.t(15, w: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Day ${d.day} · ${shortDate(DateTime.parse(c.dateKey))}',
                      style: AppText.t(13, color: AppColors.muted)),
                ],
              ),
            ),
            const AppIcon('right', size: 22, color: AppColors.faint),
          ],
        ),
      ));
    }

    return Scaffold(
      body: GlassPage(
        title: 'Completed devotionals',
        showBack: true,
        bottomPadding: Insets.bottom(context) + 32,
        children: [
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 56, 40, 0),
              child: Column(
                children: [
                  const IconTile('check-square', size: 64),
                  const SizedBox(height: 20),
                  Text('Nothing completed yet. Finish today’s devotional to see it here.',
                      textAlign: TextAlign.center, style: AppText.t(14, color: AppColors.muted, lh: 22)),
                ],
              ),
            )
          else
            for (var i = 0; i < rows.length; i++)
              Padding(padding: const EdgeInsets.only(bottom: 12), child: FadeSlideIn(index: i, child: rows[i])),
        ],
      ),
    );
  }
}
