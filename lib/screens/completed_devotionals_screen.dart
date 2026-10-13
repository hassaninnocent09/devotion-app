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
    final items = s.completedDevotionals;
    return Scaffold(
      body: Column(
        children: [
          const BackHeader('Completed devotionals'),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('Nothing completed yet.',
                        style: AppText.t(13, color: AppColors.muted)),
                  )
                : ListView(
                    padding: EdgeInsets.only(bottom: Insets.bottom(context) + 24),
                    children: [
                      for (final c in items)
                        if (s.devotionalById(c.devotionalId) case final d?)
                          InkWell(
                            onTap: () =>
                                AppNav.push(context, DevotionalReadingScreen(devotional: d)),
                            child: Container(
                              height: 78,
                              margin: const EdgeInsets.symmetric(horizontal: 26),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
                              ),
                              child: Row(
                                children: [
                                  const AppIcon('check-square', size: 22, color: AppColors.inkDim),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(d.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppText.t(13, w: FontWeight.w600, lh: 18)),
                                        const SizedBox(height: 10),
                                        Text(shortDate(DateTime.parse(c.dateKey)),
                                            style: AppText.t(13, color: AppColors.muted, lh: 18)),
                                      ],
                                    ),
                                  ),
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
