import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class ReadingHistoryScreen extends StatelessWidget {
  const ReadingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final items = s.history;

    return Scaffold(
      body: GlassPage(
        title: 'Reading history',
        showBack: true,
        bottomPadding: Insets.bottom(context) + 32,
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 56, 40, 0),
              child: Column(
                children: [
                  const IconTile('history', size: 64),
                  const SizedBox(height: 20),
                  Text('Chapters you read will appear here.',
                      textAlign: TextAlign.center, style: AppText.t(14, color: AppColors.muted, lh: 22)),
                ],
              ),
            )
          else
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FadeSlideIn(
                  index: i,
                  child: AppCard(
                    onTap: () {
                      final b = s.bookByName(items[i].book);
                      if (b != null) AppNav.openReader(context, b, items[i].chapter);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        const IconTile('history', size: 44),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${items[i].book} ${items[i].chapter}',
                                  style: AppText.t(15, w: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(shortDate(items[i].at), style: AppText.t(13, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const AppIcon('right', size: 22, color: AppColors.faint),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
