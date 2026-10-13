import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    Widget row(String icon, String label, VoidCallback onTap, {bool last = false}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          height: 54,
          padding: const EdgeInsets.fromLTRB(18, 0, 22, 0),
          decoration: BoxDecoration(
            border: last ? null : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
          ),
          child: Row(
            children: [
              AppIcon(icon, size: 18, color: AppColors.inkDim),
              const SizedBox(width: 22),
              Expanded(child: Text(label, style: AppText.t(14, color: AppColors.inkDim))),
              const AppIcon('right', size: 14, color: AppColors.muted),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const BackHeader('Settings'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 32),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 14),
                  child: Text('Bible text size', style: AppText.t(13, color: AppColors.muted, lh: 18)),
                ),
                AppSegmented(
                  labels: const ['Small', 'Medium', 'Large'],
                  index: s.textSize,
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  onChanged: s.setTextSize,
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
                        row('settings', 'Reset demo data', () async {
                          final ok = await confirmDialog(
                            context,
                            title: 'Reset demo data?',
                            message: 'This restores the sample bookmarks, plan progress and history.',
                            confirmLabel: 'Reset',
                          );
                          if (ok && context.mounted) {
                            s.resetDemoData();
                            showToast(context, 'Demo data restored');
                          }
                        }),
                        row('user', 'Sign out', () async {
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
          ),
        ],
      ),
    );
  }
}
