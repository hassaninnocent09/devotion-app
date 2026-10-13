import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

/// Screen 7 – Bookmarks (Verses / Passages).
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final verses = s.savedVerses;
    final passages = s.passages;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, Insets.top(context) + 28, 24, 0),
                child: Text('Bookmarks', style: AppText.t(24, w: FontWeight.w700, lh: 28)),
              ),
              const SizedBox(height: 30),
              AppSegmented(
                labels: const ['Verses', 'Passages'],
                index: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              Expanded(
                child: _tab == 0
                    ? _list(
                        empty: 'No saved verses yet.\nTap a verse while reading to save it.',
                        children: [
                          for (final v in verses)
                            _Row(
                              icon: v.bookmarked ? 'bookmark' : 'pencil',
                              title: v.ref,
                              body: (v.note ?? '').isNotEmpty ? v.note! : v.text,
                              added: v.addedAt,
                              onTap: () {
                                final b = s.bookByName(v.book);
                                if (b != null) {
                                  AppNav.openReader(context, b, v.chapter, startVerse: v.verse);
                                }
                              },
                            ),
                        ],
                      )
                    : _list(
                        empty: 'No saved passages yet.\nBookmark a devotional’s scripture to save it.',
                        children: [
                          for (final p in passages)
                            _Row(
                              icon: 'bookmark',
                              title: p.ref,
                              body: p.text,
                              added: p.addedAt,
                              onTap: () {
                                final r = PassageRef.parse(p.ref);
                                if (r != null) {
                                  AppNav.openReader(context, r.book, r.chapter,
                                      startVerse: r.start, endVerse: r.end);
                                }
                              },
                            ),
                        ],
                      ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppTabBar(
              current: 1,
              onTap: (i) {
                s.setTab(i);
                AppNav.popToRoot(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _list({required String empty, required List<Widget> children}) {
    if (children.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: AppTabBar.height(context)),
          child: Text(empty,
              textAlign: TextAlign.center,
              style: AppText.t(13, color: AppColors.muted, lh: 22)),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.only(bottom: AppTabBar.height(context) + 16),
      children: children,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.body,
    required this.added,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String body;
  final DateTime added;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 166),
        padding: const EdgeInsets.fromLTRB(30, 49, 24, 0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 20, child: AppIcon(icon, size: 18, color: AppColors.inkDim)),
            const SizedBox(width: 26),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.t(15, w: FontWeight.w700, lh: 20)),
                  const SizedBox(height: 9),
                  Text(body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.t(13, color: AppColors.muted, lh: 27)),
                  const SizedBox(height: 15),
                  Text('Added ${shortDate(added)}',
                      style: AppText.t(13, color: AppColors.faint, lh: 18)),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
