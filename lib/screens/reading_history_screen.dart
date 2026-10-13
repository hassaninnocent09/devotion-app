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
      body: Column(
        children: [
          const BackHeader('Reading history'),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('Chapters you read will appear here.',
                        style: AppText.t(13, color: AppColors.muted)),
                  )
                : ListView(
                    padding: EdgeInsets.only(bottom: Insets.bottom(context) + 24),
                    children: [
                      for (final h in items)
                        InkWell(
                          onTap: () {
                            final b = s.bookByName(h.book);
                            if (b != null) AppNav.openReader(context, b, h.chapter);
                          },
                          child: Container(
                            height: 78,
                            margin: const EdgeInsets.symmetric(horizontal: 26),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
                            ),
                            child: Row(
                              children: [
                                const AppIcon('history', size: 22, color: AppColors.inkDim),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${h.book} ${h.chapter}',
                                          style: AppText.t(13, w: FontWeight.w600, lh: 18)),
                                      const SizedBox(height: 10),
                                      Text(shortDate(h.at),
                                          style: AppText.t(13, color: AppColors.muted, lh: 18)),
                                    ],
                                  ),
                                ),
                                const AppIcon('right', size: 14, color: AppColors.muted),
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
