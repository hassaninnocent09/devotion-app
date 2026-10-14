import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'bookmarks_screen.dart';
import 'completed_devotionals_screen.dart';
import 'reading_history_screen.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';

/// You / profile.
class YouScreen extends StatelessWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    Future<void> editName() async {
      final v = await showTextSheet(context, title: 'Your name', hint: 'Enter your name', initial: s.name);
      if (v != null) s.setName(v);
    }

    final items = <(String, String, VoidCallback)>[
      ('history', 'Reading history', () => AppNav.push(context, const ReadingHistoryScreen())),
      ('bookmark', 'Bookmarks', () => AppNav.push(context, const BookmarksScreen())),
      ('check-square', 'Completed devotionals', () => AppNav.push(context, const CompletedDevotionalsScreen())),
      ('plans', 'Reading plans', () => s.setTab(2)),
      ('bell', 'Reminders', () => AppNav.push(context, const RemindersScreen())),
      ('settings', 'Settings', () => AppNav.push(context, const SettingsScreen())),
    ];

    Widget stat(String value, String label) => Expanded(
          child: Column(
            children: [
              Text(value, style: AppText.serif(26, w: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(label, style: AppText.t(12, w: FontWeight.w500, color: AppColors.muted)),
            ],
          ),
        );

    return GlassPage(
      title: 'You',
      bottomPadding: AppTabBar.height(context) + 28,
      children: [
        FadeSlideIn(
          index: 1,
          child: AppCard(
            onTap: editName,
            child: Row(
              children: [
                const AppAvatar(size: 68),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.serif(24, w: FontWeight.w500, lh: 30)),
                      const SizedBox(height: 4),
                      Text('View and edit profile', style: AppText.t(13, color: AppColors.muted)),
                    ],
                  ),
                ),
                const AppIcon('right', size: 22, color: AppColors.faint),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FadeSlideIn(
          index: 2,
          child: AppCard(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                stat('${s.completedCount}', 'Devotionals'),
                stat('${s.streak}', 'Day streak'),
                stat('${s.history.length}', 'Chapters read'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeSlideIn(
          index: 3,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  Pressable(
                    scale: 0.99,
                    onTap: items[i].$3,
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: i == items.length - 1
                            ? null
                            : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
                      ),
                      child: Row(
                        children: [
                          IconTile(items[i].$1, size: 38),
                          const SizedBox(width: 14),
                          Expanded(child: Text(items[i].$2, style: AppText.t(15, w: FontWeight.w500))),
                          const AppIcon('right', size: 22, color: AppColors.faint),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
