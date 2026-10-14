import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'devotional_complete_screen.dart';

/// Devotional reading: Scripture → Devotion → Reflect → Pray → Take action.
class DevotionalReadingScreen extends StatefulWidget {
  const DevotionalReadingScreen({super.key, required this.devotional});
  final Devotional devotional;

  @override
  State<DevotionalReadingScreen> createState() => _DevotionalReadingScreenState();
}

class _DevotionalReadingScreenState extends State<DevotionalReadingScreen> {
  final _scroll = ScrollController();
  double _t = 0; // header blur
  double _progress = 0; // reading progress

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      final p = max <= 0 ? 0.0 : (_scroll.offset / max).clamp(0.0, 1.0).toDouble();
      final t = ((_scroll.offset - 120) / 60).clamp(0.0, 1.0).toDouble();
      if ((t - _t).abs() > 0.01 || (p - _progress).abs() > 0.004) {
        setState(() {
          _t = t;
          _progress = p;
        });
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _readPassage() {
    final r = PassageRef.parse(widget.devotional.reference);
    if (r == null) return;
    AppNav.openReader(context, r.book, r.chapter, startVerse: r.start, endVerse: r.end);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final d = widget.devotional;
    final top = Insets.top(context);
    final done = s.isDoneToday(d);
    final saved = s.isPassageSaved(d.reference);
    final paragraphs = d.paragraphs;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: top + 190,
                  child: const Stack(fit: StackFit.expand, children: [AppPhoto('hills')]),
                ),
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeSlideIn(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Chip('Day ${d.day}'),
                              _Chip(d.category),
                              _Chip('${d.minutes} min read'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        FadeSlideIn(
                          index: 1,
                          child: Text(d.title, style: AppText.serif(30, w: FontWeight.w500, lh: 38)),
                        ),
                        const SizedBox(height: 8),
                        FadeSlideIn(
                          index: 2,
                          child: Text(d.subtitle, style: AppText.t(15, color: AppColors.muted)),
                        ),
                        const SizedBox(height: 28),
                        FadeSlideIn(
                          index: 3,
                          child: _ScriptureCard(devotional: d, onRead: _readPassage),
                        ),
                        const _Eyebrow('Devotion', 'open-book'),
                        for (var i = 0; i < paragraphs.length; i++)
                          Padding(
                            padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
                            child: Text(paragraphs[i],
                                style: AppText.t(15, color: AppColors.inkDim, lh: 28)),
                          ),
                        const _Eyebrow('Reflect', 'note'),
                        for (var i = 0; i < d.questions.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppCard(
                              margin: EdgeInsets.zero,
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Color(0x1F355539), shape: BoxShape.circle),
                                    child: Text('${i + 1}',
                                        style: AppText.t(13, w: FontWeight.w600, color: AppColors.green)),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(d.questions[i],
                                        style: AppText.t(15, w: FontWeight.w500, lh: 23)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const _Eyebrow('Pray', 'prayer'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3A5E40), Color(0xFF2F4A34)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(d.prayer,
                              style: AppText.serif(16, color: const Color(0xFFF4EFE2), lh: 27)),
                        ),
                        const _Eyebrow('Take action', 'flag'),
                        AppCard(
                          margin: EdgeInsets.zero,
                          color: const Color(0xFFF4EBCB),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppIcon('flag', size: 24, color: Color(0xFF8A6D1F), filled: true),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(d.action,
                                    style: AppText.t(15, w: FontWeight.w500, lh: 23, color: AppColors.ink)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          done ? 'Completed' : 'Mark as complete',
                          onTap: () {
                            if (!done) {
                              s.completeDevotional(d);
                            }
                            AppNav.push(context, DevotionalCompleteScreen(devotional: d));
                          },
                        ),
                        SizedBox(height: 32 + Insets.bottom(context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Frosted header with reading progress
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: top + 56,
            child: Stack(
              children: [
                Positioned.fill(child: GlassBackdrop(opacity: _t, borderBottom: false)),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 0,
                  height: 56,
                  child: Row(
                    children: [
                      GlassIconButton(icon: 'left', dark: _t < 0.5, onTap: () => Navigator.of(context).maybePop()),
                      Expanded(
                        child: Opacity(
                          opacity: _t,
                          child: Text(d.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.t(15, w: FontWeight.w600)),
                        ),
                      ),
                      GlassIconButton(
                        icon: 'bookmark',
                        filled: saved,
                        dark: _t < 0.5,
                        onTap: () {
                          final on = s.togglePassage(d);
                          showToast(context, on ? 'Passage saved' : 'Passage removed');
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 2,
                  child: Opacity(
                    opacity: _t,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _progress,
                        child: const ColoredBox(color: AppColors.green, child: SizedBox(height: 2)),
                      ),
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

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.segment, borderRadius: BorderRadius.circular(14)),
      child: Text(label, style: AppText.t(12, w: FontWeight.w600, color: AppColors.inkDim)),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.label, this.icon);
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 14),
      child: Row(
        children: [
          AppIcon(icon, size: 20, color: AppColors.green),
          const SizedBox(width: 10),
          Text(label.toUpperCase(),
              style: AppText.t(12, w: FontWeight.w600, color: AppColors.green, ls: 1.2)),
        ],
      ),
    );
  }
}

class _ScriptureCard extends StatelessWidget {
  const _ScriptureCard({required this.devotional, required this.onRead});
  final Devotional devotional;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final d = devotional;
    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIcon('quote', size: 24, color: AppColors.green2, filled: true),
              const SizedBox(width: 8),
              Text('${d.reference} · ${d.translation}',
                  style: AppText.t(13, w: FontWeight.w600, color: AppColors.green2)),
            ],
          ),
          const SizedBox(height: 14),
          Text(d.keyVerse, style: AppText.serif(18, lh: 29)),
          const SizedBox(height: 12),
          Pressable(
            onTap: onRead,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text('Read full passage', style: AppText.t(14, w: FontWeight.w600, color: AppColors.green)),
                  const SizedBox(width: 6),
                  const AppIcon('forward', size: 18, color: AppColors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
