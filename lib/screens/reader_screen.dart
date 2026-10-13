import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/bible_service.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';

/// Screens 5 + 6 – Bible reading with verse options.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
    required this.book,
    required this.chapter,
    this.startVerse,
    this.endVerse,
    this.planId,
    this.planDay,
  });

  final Book book;
  final int chapter;
  final int? startVerse;
  final int? endVerse;
  final String? planId;
  final int? planDay;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  static const _sizes = [18.0, 20.0, 23.0];

  late int _chapter = widget.chapter;
  int? _start;
  int? _end;
  String? _planId;
  int? _planDay;

  List<Verse>? _verses;
  bool _failed = false;
  int? _selected;
  bool _focus = false;

  final _scroll = ScrollController();
  final Map<int, GlobalKey> _keys = {};
  Timer? _timer;
  DateTime? _loadedAt;
  bool _planDone = false;

  @override
  void initState() {
    super.initState();
    _start = widget.startVerse;
    _end = widget.endVerse;
    _planId = widget.planId;
    _planDay = widget.planDay;
    if (widget.startVerse != null && widget.endVerse == null && widget.planId == null) {
      _selected = widget.startVerse;
    }
    _load();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _checkPlanEnd());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _verses = null;
      _failed = false;
    });
    try {
      final v = await context.read<BibleService>().getChapter(widget.book, _chapter);
      if (!mounted) return;
      _keys
        ..clear()
        ..addEntries(v.map((x) => MapEntry(x.number, GlobalKey())));
      setState(() => _verses = v);
      _loadedAt = DateTime.now();
      context.read<AppState>().logVisit(widget.book, _chapter);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToStart());
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  void _scrollToStart() {
    final s = _start;
    if (!mounted || s == null || s <= 1) return;
    final ctx = _keys[s]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.12,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  /// A plan day completes once its last verse has been on screen for a moment.
  void _checkPlanEnd() {
    if (!mounted || _planDone || _planId == null || _planDay == null) return;
    final v = _verses;
    final loaded = _loadedAt;
    if (v == null || v.isEmpty || loaded == null) return;
    if (DateTime.now().difference(loaded).inSeconds < 6) return;
    final endNum = _end ?? v.last.number;
    final ctx = _keys[endNum]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.attached) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.sizeOf(context).height;
    if (dy < screenH - 110) {
      _planDone = true;
      final fresh = context.read<AppState>().completePlanDay(_planId!, _planDay!);
      if (fresh) showToast(context, 'Day $_planDay complete');
    }
  }

  Future<void> _pickChapter() async {
    final c = await showChapterPicker(context, widget.book, current: _chapter);
    if (c == null || c == _chapter || !mounted) return;
    setState(() {
      _chapter = c;
      _start = null;
      _end = null;
      _planId = null;
      _planDay = null;
      _selected = null;
      _planDone = false;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
    _load();
  }

  Verse? get _selectedVerse {
    final n = _selected;
    final list = _verses;
    if (n == null || list == null) return null;
    for (final v in list) {
      if (v.number == n) return v;
    }
    return null;
  }

  void _onVerse(Verse v) {
    setState(() => _selected = v.number);
    showVerseOptions(context, book: widget.book, chapter: _chapter, verse: v);
  }

  void _withVerse(void Function(Verse v) action) {
    final v = _selectedVerse;
    if (v == null) {
      showToast(context, 'Tap a verse first');
      return;
    }
    action(v);
  }

  void _shareChapter() {
    final list = _verses;
    if (list == null) return;
    final text = '${widget.book.name} $_chapter\n\n${list.map((v) => '${v.number} ${v.text}').join('\n')}';
    Clipboard.setData(ClipboardData(text: text));
    showToast(context, 'Chapter copied, ready to share');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final fontSize = _sizes[s.textSize];
    final saved = _selected == null
        ? null
        : s.savedVerse(widget.book.name, _chapter, _selected!);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(28, Insets.top(context) + 26, 28, 0),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 14, top: 10, bottom: 10),
                          child: AppIcon('left', size: 18),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _pickChapter,
                        child: Row(
                          children: [
                            Text('${widget.book.name} $_chapter',
                                style: AppText.t(14, w: FontWeight.w700)),
                            const SizedBox(width: 4),
                            const AppIcon('down', size: 12),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _shareChapter,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 14, top: 10, bottom: 10),
                          child: AppIcon('share', size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: _body(fontSize)),
            ],
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: math.max(24.0, Insets.bottom(context) + 12),
            child: _toolbar(s, saved),
          ),
        ],
      ),
    );
  }

  Widget _body(double fontSize) {
    if (_failed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Couldn’t load this chapter',
                  textAlign: TextAlign.center, style: AppText.t(14, w: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: AppText.t(13, color: AppColors.muted, lh: 20)),
              const SizedBox(height: 18),
              SizedBox(
                width: 160,
                child: PrimaryButton('Try again', height: 44, onTap: _load),
              ),
            ],
          ),
        ),
      );
    }
    final list = _verses;
    if (list == null) {
      return const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.green),
        ),
      );
    }

    final state = context.watch<AppState>();
    final lh = fontSize * 1.95;
    return SingleChildScrollView(
      controller: _scroll,
      padding: EdgeInsets.only(top: 55, bottom: 150 + Insets.bottom(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final v in list)
            KeyedSubtree(
              key: _keys[v.number],
              child: _VerseRow(
                verse: v,
                fontSize: fontSize,
                lineHeight: lh,
                selected: _selected == v.number,
                highlighted:
                    state.savedVerse(widget.book.name, _chapter, v.number)?.highlighted == true,
                dimmed: _focus && _selected != null && _selected != v.number,
                onTap: () => _onVerse(v),
              ),
            ),
        ],
      ),
    );
  }

  Widget _toolbar(AppState s, SavedVerse? saved) {
    Widget btn(Widget child, VoidCallback onTap) => Expanded(
          child: InkResponse(
            onTap: onTap,
            radius: 30,
            child: SizedBox(height: 80, child: Center(child: child)),
          ),
        );

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.toolbar,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x24504628), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          btn(
            AppIcon('bookmark',
                size: 24,
                filled: saved?.bookmarked == true,
                color: saved?.bookmarked == true ? AppColors.green : AppColors.toolbarIcon),
            () => _withVerse((v) {
              final on = s.toggleBookmark(widget.book, _chapter, v);
              showToast(context, on ? 'Bookmark added' : 'Bookmark removed');
            }),
          ),
          btn(
            AppIcon('underline',
                size: 24,
                color: saved?.highlighted == true ? AppColors.green : AppColors.toolbarIcon),
            () => _withVerse((v) {
              final on = s.toggleHighlight(widget.book, _chapter, v);
              showToast(context, on ? 'Verse highlighted' : 'Highlight removed');
            }),
          ),
          btn(
            const AppIcon('link', size: 24, color: AppColors.toolbarIcon),
            () => _withVerse((v) {
              Clipboard.setData(ClipboardData(text: '${widget.book.name} $_chapter:${v.number}'));
              showToast(context, 'Reference copied');
            }),
          ),
          btn(
            Text('Aa', style: AppText.t(17, w: FontWeight.w600, color: AppColors.toolbarIcon)),
            () => s.setTextSize((s.textSize + 1) % 3),
          ),
          btn(
            AppIcon('target',
                size: 24, color: _focus ? AppColors.green : AppColors.toolbarIcon),
            () {
              setState(() => _focus = !_focus);
              showToast(context, _focus ? 'Focus mode on' : 'Focus mode off');
            },
          ),
        ],
      ),
    );
  }
}

class _VerseRow extends StatelessWidget {
  const _VerseRow({
    required this.verse,
    required this.fontSize,
    required this.lineHeight,
    required this.selected,
    required this.highlighted,
    required this.dimmed,
    required this.onTap,
  });

  final Verse verse;
  final double fontSize;
  final double lineHeight;
  final bool selected;
  final bool highlighted;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = highlighted
        ? AppColors.verseHighlight
        : (selected ? AppColors.field : Colors.transparent);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.35 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 31),
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 32,
                child: Text('${verse.number}',
                    style: AppText.t(13, color: AppColors.inkDim, lh: lineHeight)),
              ),
              Expanded(
                child: Text(verse.text,
                    style: AppText.t(fontSize, color: AppColors.verseInk, lh: lineHeight)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

