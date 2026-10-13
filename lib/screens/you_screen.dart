import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';
import 'bookmarks_screen.dart';
import 'completed_devotionals_screen.dart';
import 'reading_history_screen.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';

/// Screen 14 – You / profile.
class YouScreen extends StatelessWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    Future<void> editName() async {
      final v = await showTextSheet(context,
          title: 'Your name', hint: 'Enter your name', initial: s.name);
      if (v != null) s.setName(v);
    }

    final items = <(String, String, VoidCallback)>[
      ('history', 'Reading history', () => AppNav.push(context, const ReadingHistoryScreen())),
      ('bookmark', 'Bookmarks', () => AppNav.push(context, const BookmarksScreen())),
      ('check-square', 'Completed devotionals',
          () => AppNav.push(context, const CompletedDevotionalsScreen())),
      ('plans', 'Reading plans', () => s.setTab(2)),
      ('bell', 'Reminders', () => AppNav.push(context, const RemindersScreen())),
      ('settings', 'Settings', () => AppNav.push(context, const SettingsScreen())),
    ];

    return ListView(
      primary: false,
      padding: EdgeInsets.only(top: Insets.top(context), bottom: AppTabBar.height(context) + 16),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 28, 30, 0),
          child: Text('You', style: AppText.t(13, color: AppColors.muted, lh: 18)),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: editName,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 18, 30, 0),
            child: Row(
              children: [
                const AppAvatar(size: 76),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.t(19, w: FontWeight.w700, lh: 24)),
                      const SizedBox(height: 16),
                      Text('View and edit profile',
                          style: AppText.t(13, color: AppColors.muted, lh: 18)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(22, 32, 22, 0),
          decoration: BoxDecoration(
            color: AppColors.menu,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  InkWell(
                    onTap: items[i].$3,
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.fromLTRB(18, 0, 22, 0),
                      decoration: BoxDecoration(
                        border: i == items.length - 1
                            ? null
                            : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
                      ),
                      child: Row(
                        children: [
                          AppIcon(items[i].$1, size: 18, color: AppColors.inkDim),
                          const SizedBox(width: 22),
                          Expanded(
                            child: Text(items[i].$2,
                                style: AppText.t(14, color: AppColors.inkDim)),
                          ),
                          const AppIcon('right', size: 14, color: AppColors.muted),
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
