import 'package:flutter/material.dart';
import '../data/bible_books.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
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
  int _testament = 0; // 0 old, 1 new

  @override
  void dispose() {
    _search.dispose();
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
          out.add(_Result(vs == null ? '${b.name} $ch' : '${b.name} $ch:$vs', b,
              chapter: ch, verse: vs));
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
    FocusScope.of(context).unfocus();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, Insets.top(context) + 28, 24, 0),
          child: Text('Bible', style: AppText.t(24, w: FontWeight.w700, lh: 28)),
        ),
        Container(
          height: 44,
          margin: const EdgeInsets.fromLTRB(22, 26, 22, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const AppIcon('search', size: 15, color: AppColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  style: AppText.t(13, color: AppColors.ink),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Search books, chapters or verses',
                    hintStyle: AppText.t(13, color: AppColors.muted),
                  ),
                ),
              ),
              if (searching)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(_search.clear),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.close_rounded, size: 16, color: AppColors.muted),
                  ),
                ),
            ],
          ),
        ),
        if (!searching)
          UnderlineTabs(
            labels: const ['Old Testament', 'New Testament'],
            index: _testament,
            margin: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            onChanged: (i) => setState(() => _testament = i),
          ),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text('No results', style: AppText.t(13, color: AppColors.muted)),
                )
              : ListView.builder(
                  primary: false,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(top: 17, bottom: AppTabBar.height(context) + 16),
                  itemCount: results.length,
                  itemBuilder: (_, i) {
                    final r = results[i];
                    return InkWell(
                      onTap: () => _open(r),
                      child: Container(
                        height: 54,
                        padding: const EdgeInsets.only(left: 30, right: 40),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r.label, style: AppText.t(14, w: FontWeight.w500)),
                            const AppIcon('right', size: 14, color: AppColors.muted),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
