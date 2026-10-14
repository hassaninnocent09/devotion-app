import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

/// Bookmarks (Verses / Passages).
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
    final items = <Widget>[];

    if (_tab == 0) {
      for (final v in s.savedVerses) {
        items.add(_Item(
          key: ValueKey('v${v.ref}'),
          icon: v.bookmarked ? 'bookmark' : 'pencil',
          title: v.ref,
          body: (v.note ?? '').isNotEmpty ? v.note! : v.text,
          added: v.addedAt,
          onTap: () {
            final b = s.bookByName(v.book);
            if (b != null) AppNav.openReader(context, b, v.chapter, startVerse: v.verse);
          },
        ));
      }
    } else {
      for (final p in s.passages) {
        items.add(_Item(
          key: ValueKey('p${p.ref}'),
          icon: 'bookmark',
          title: p.ref,
          body: p.text,
          added: p.addedAt,
          onTap: () {
            final r = PassageRef.parse(p.ref.replaceAll('–', '-'));
            if (r != null) {
              AppNav.openReader(context, r.book, r.chapter, startVerse: r.start, endVerse: r.end);
            }
          },
        ));
      }
    }

    return Scaffold(
      body: GlassPage(
        title: 'Bookmarks',
        showBack: true,
        bottomPadding: AppTabBar.height(context) + 28,
        bottomBar: AppTabBar(
          current: 1,
          onTap: (i) {
            s.setTab(i);
            AppNav.popToRoot(context);
          },
        ),
        children: [
          FadeSlideIn(
            index: 1,
            child: AppSegmented(
              labels: const ['Verses', 'Passages'],
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          const SizedBox(height: 20),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 56, 40, 0),
              child: Column(
                children: [
                  const IconTile('bookmark', size: 64),
                  const SizedBox(height: 20),
                  Text(
                    _tab == 0
                        ? 'No saved verses yet. Tap a verse while reading to save it.'
                        : 'No saved passages yet. Bookmark a devotional to save its scripture.',
                    textAlign: TextAlign.center,
                    style: AppText.t(14, color: AppColors.muted, lh: 22),
                  ),
                ],
              ),
            )
          else
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FadeSlideIn(index: i + 2, child: items[i]),
              ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
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
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon, size: 40, filled: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.t(15, w: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.serif(14, color: AppColors.inkDim, lh: 22)),
                const SizedBox(height: 10),
                Text('Added ${shortDate(added)}', style: AppText.t(12, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
