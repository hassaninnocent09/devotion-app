import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    Widget row(String icon, String label, VoidCallback onTap, {bool last = false}) {
      return Pressable(
        scale: 0.99,
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: last ? null : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
          ),
          child: Row(
            children: [
              IconTile(icon, size: 38),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: AppText.t(15, w: FontWeight.w500))),
              const AppIcon('right', size: 22, color: AppColors.faint),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: GlassPage(
        title: 'Settings',
        showBack: true,
        bottomPadding: Insets.bottom(context) + 32,
        children: [
          const SectionLabel('Bible text size', padding: EdgeInsets.fromLTRB(24, 8, 24, 12)),
          FadeSlideIn(
            child: AppSegmented(
              labels: const ['Small', 'Medium', 'Large'],
              index: s.textSize,
              onChanged: s.setTextSize,
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 1,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  row('refresh', 'Reset demo data', () async {
                    final ok = await confirmDialog(
                      context,
                      title: 'Reset demo data?',
                      message: 'This restores the sample bookmarks, plan progress and history, and clears completed devotionals.',
                      confirmLabel: 'Reset',
                    );
                    if (ok && context.mounted) {
                      s.resetDemoData();
                      showToast(context, 'Demo data restored');
                    }
                  }),
                  row('logout', 'Sign out', () async {
                    final ok = await confirmDialog(
                      context,
                      title: 'Sign out?',
                      message: 'You’ll return to the welcome screen.',
                      confirmLabel: 'Sign out',
                    );
                    if (ok && context.mounted) {
                      AppNav.popToRoot(context);
                      s.signOut();
                    }
                  }, last: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
