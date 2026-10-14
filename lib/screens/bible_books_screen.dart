import 'package:flutter/material.dart';
import '../data/bible_books.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class _Result {
  const _Result(this.label, this.book, {this.chapter, this.verse});
  final String label;
  final Book book;
  final int? chapter;
  final int? verse;
}

class BibleBooksScreen extends StatefulWidget {
  const BibleBooksScreen({super.key});

  @override
  State<BibleBooksScreen> createState() => _BibleBooksScreenState();
}

class _BibleBooksScreenState extends State<BibleBooksScreen> {
  final _search = TextEditingController();
  final _focus = FocusNode();
  int _testament = 0; // 0 old, 1 new

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  static final _refRe = RegExp(r'^(.*?)\s*(\d+)(?::(\d+))?$');

  List<_Result> _results() {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) {
      return BibleBooks.testament(old: _testament == 0).map((b) => _Result(b.name, b)).toList();
    }
    final m = _refRe.firstMatch(q);
    if (m != null && m.group(1)!.trim().isNotEmpty) {
      final namePart = m.group(1)!.trim();
      final ch = int.parse(m.group(2)!);
      final vs = m.group(3) == null ? null : int.parse(m.group(3)!);
      final out = <_Result>[];
      for (final b in BibleBooks.all) {
        if (b.name.toLowerCase().contains(namePart) && ch >= 1 && ch <= b.chapters) {
          out.add(_Result(vs == null ? '${b.name} $ch' : '${b.name} $ch:$vs', b, chapter: ch, verse: vs));
        }
      }
      return out;
    }
    return BibleBooks.all
        .where((b) => b.name.toLowerCase().contains(q))
        .map((b) => _Result(b.name, b))
        .toList();
  }

  Future<void> _open(_Result r) async {
    _focus.unfocus();
    var chapter = r.chapter;
    if (chapter == null) {
      if (r.book.chapters == 1) {
        chapter = 1;
      } else {
        chapter = await showChapterPicker(context, r.book);
        if (chapter == null || !mounted) return;
      }
    }
    if (!mounted) return;
    await AppNav.openReader(context, r.book, chapter, startVerse: r.verse);
  }

  @override
  Widget build(BuildContext context) {
    final results = _results();
    final searching = _search.text.trim().isNotEmpty;

    return GlassPage(
      title: 'Bible',
      bottomPadding: AppTabBar.height(context) + 28,
      children: [
        FadeSlideIn(
          index: 1,
          child: Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                const AppIcon('search', size: 22, color: AppColors.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _search,
                    focusNode: _focus,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    style: AppText.t(14, color: AppColors.ink),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: 'Search books, chapters or verses',
                      hintStyle: AppText.t(14, color: AppColors.muted),
                    ),
                  ),
                ),
                if (searching)
                  Pressable(
                    onTap: () => setState(_search.clear),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: AppIcon('close', size: 20, color: AppColors.muted),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (!searching) ...[
          const SizedBox(height: 16),
          FadeSlideIn(
            index: 2,
            child: AppSegmented(
              labels: const ['Old Testament', 'New Testament'],
              index: _testament,
              onChanged: (i) => setState(() => _testament = i),
            ),
          ),
        ],
        const SizedBox(height: 20),
        if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(child: Text('No results', style: AppText.t(14, color: AppColors.muted))),
          )
        else
          FadeSlideIn(
            index: 3,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: Column(
                  key: ValueKey('$_testament$searching'),
                  children: [
                    for (var i = 0; i < results.length; i++)
                      Pressable(
                        scale: 0.99,
                        onTap: () => _open(results[i]),
                        child: Container(
                          height: 58,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            border: i == results.length - 1
                                ? null
                                : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(results[i].label, style: AppText.t(15, w: FontWeight.w500)),
                              ),
                              if (results[i].chapter == null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text('${results[i].book.chapters}',
                                      style: AppText.t(13, color: AppColors.muted)),
                                ),
                              const AppIcon('right', size: 22, color: AppColors.faint),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
