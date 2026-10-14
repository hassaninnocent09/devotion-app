import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/bible_service.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';

/// Bible reading with verse options (offline KJV).
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
  static const _sizes = [18.0, 20.0, 22.5];

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
  double _t = 0;

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
    _scroll.addListener(() {
      final t = (_scroll.hasClients ? _scroll.offset / 36 : 0.0).clamp(0.0, 1.0).toDouble();
      if ((t - _t).abs() > 0.01) setState(() => _t = t);
    });
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
    Scrollable.ensureVisible(ctx,
        alignment: 0.18, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
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
    if (dy < MediaQuery.sizeOf(context).height - 140) {
      _planDone = true;
      final fresh = context.read<AppState>().completePlanDay(_planId!, _planDay!);
      if (fresh) showToast(context, 'Day $_planDay complete');
    }
  }

  void _goChapter(int c) {
    if (c < 1 || c > widget.book.chapters || c == _chapter) return;
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

  Future<void> _pickChapter() async {
    final c = await showChapterPicker(context, widget.book, current: _chapter);
    if (c != null && mounted) _goChapter(c);
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
    HapticFeedback.selectionClick();
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
    final text =
        '${widget.book.name} $_chapter (KJV)\n\n${list.map((v) => '${v.number} ${v.text}').join('\n')}';
    Clipboard.setData(ClipboardData(text: text));
    showToast(context, 'Chapter copied, ready to share');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final top = Insets.top(context);
    final saved = _selected == null ? null : s.savedVerse(widget.book.name, _chapter, _selected!);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _body(s)),
          // Frosted header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: top + 56,
            child: Stack(
              children: [
                Positioned.fill(child: GlassBackdrop(opacity: _t, borderBottom: true)),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 0,
                  height: 56,
                  child: Row(
                    children: [
                      const AppBackButton(),
                      Expanded(
                        child: Center(
                          child: Pressable(
                            onTap: _pickChapter,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
                              decoration: BoxDecoration(
                                color: AppColors.field,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${widget.book.name} $_chapter',
                                      style: AppText.t(14, w: FontWeight.w600)),
                                  const SizedBox(width: 2),
                                  const AppIcon('down', size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Pressable(
                        onTap: _shareChapter,
                        scale: 0.88,
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(child: AppIcon('share', size: 22)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: Insets.bottom(context) + 16,
            child: _toolbar(s, saved),
          ),
        ],
      ),
    );
  }

  Widget _body(AppState state) {
    final top = Insets.top(context);
    if (_failed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Couldn’t load this chapter',
                  textAlign: TextAlign.center, style: AppText.t(15, w: FontWeight.w600)),
              const SizedBox(height: 18),
              SizedBox(width: 160, child: PrimaryButton('Try again', height: 46, onTap: _load)),
            ],
          ),
        ),
      );
    }
    final list = _verses;
    if (list == null) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.green),
        ),
      );
    }

    final fontSize = _sizes[state.textSize];
    final lh = fontSize * 1.8;
    return SingleChildScrollView(
      controller: _scroll,
      padding: EdgeInsets.only(top: top + 56 + 8, bottom: 120 + Insets.bottom(context)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        child: Column(
          key: ValueKey('${widget.book.name}$_chapter'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.book.name, style: AppText.serif(34, w: FontWeight.w500, lh: 40)),
                  const SizedBox(height: 4),
                  Text('Chapter $_chapter  ·  KJV',
                      style: AppText.t(13, w: FontWeight.w500, color: AppColors.muted)),
                ],
              ),
            ),
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _NavButton(
                      label: 'Previous',
                      icon: 'left',
                      enabled: _chapter > 1,
                      onTap: () => _goChapter(_chapter - 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _NavButton(
                      label: 'Next',
                      icon: 'forward',
                      trailingIcon: true,
                      enabled: _chapter < widget.book.chapters,
                      onTap: () => _goChapter(_chapter + 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar(AppState s, SavedVerse? saved) {
    Widget btn(Widget child, VoidCallback onTap) => Expanded(
          child: Pressable(
            onTap: onTap,
            scale: 0.88,
            child: SizedBox(height: 64, child: Center(child: child)),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(color: Color(0x2E504628), blurRadius: 28, offset: Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xD9FBF8F0),
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(32),
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
                  const AppIcon('text', size: 24, color: AppColors.toolbarIcon),
                  () => s.setTextSize((s.textSize + 1) % 3),
                ),
                btn(
                  AppIcon('focus',
                      size: 24,
                      filled: _focus,
                      color: _focus ? AppColors.green : AppColors.toolbarIcon),
                  () {
                    setState(() => _focus = !_focus);
                    showToast(context, _focus ? 'Focus mode on' : 'Focus mode off');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.trailingIcon = false,
  });

  final String label;
  final String icon;
  final bool enabled;
  final bool trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.green : AppColors.faint;
    final children = [
      if (!trailingIcon) AppIcon(icon, size: 20, color: color),
      if (!trailingIcon) const SizedBox(width: 8),
      Text(label, style: AppText.t(14, w: FontWeight.w600, color: color)),
      if (trailingIcon) const SizedBox(width: 8),
      if (trailingIcon) AppIcon(icon, size: 20, color: color),
    ];
    return Pressable(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
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
    final bg = highlighted ? AppColors.verseHighlight : (selected ? AppColors.field : Colors.transparent);
    return Pressable(
      onTap: onTap,
      scale: 0.995,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.3 : 1,
        duration: const Duration(milliseconds: 220),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 30,
                child: Text('${verse.number}',
                    style: AppText.t(12, w: FontWeight.w600, color: AppColors.green2)),
              ),
              Expanded(
                child: Text(verse.text,
                    style: AppText.serif(fontSize, color: AppColors.verseInk, lh: lineHeight)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
