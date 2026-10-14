import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';

/// Devotional completed.
class DevotionalCompleteScreen extends StatelessWidget {
  const DevotionalCompleteScreen({super.key, required this.devotional});
  final Devotional devotional;

  Future<void> _reflect(BuildContext context, AppState s) async {
    final text = await showTextSheet(
      context,
      title: 'Add a reflection',
      hint: 'What stood out to you today?',
      initial: s.reflectionToday ?? '',
      minLines: 3,
      maxLines: 6,
    );
    if (text != null) s.setReflection(text);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final reflection = s.reflectionToday;
    final has = reflection != null && reflection.isNotEmpty;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: Insets.top(context)),
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: const [AppBackButton()]),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) => Transform.scale(scale: v.clamp(0.0, 1.2).toDouble(), child: child),
                      child: Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.seal,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Color(0x4D355539), blurRadius: 30, offset: Offset(0, 12))],
                        ),
                        child: const AppIcon('check', size: 44, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeSlideIn(
                      index: 2,
                      child: Text('Today’s devotional\nis complete!',
                          textAlign: TextAlign.center,
                          style: AppText.serif(30, w: FontWeight.w500, lh: 40)),
                    ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      index: 3,
                      child: Text(
                        'Day ${devotional.day} done. You’ve taken an important step in your spiritual journey.',
                        textAlign: TextAlign.center,
                        style: AppText.t(14, color: AppColors.muted, lh: 23),
                      ),
                    ),
                    if (s.streak > 1) ...[
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        index: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppIcon('fire', size: 20, color: Color(0xFFC9892B), filled: true),
                            const SizedBox(width: 6),
                            Text('${s.streak} day streak',
                                style: AppText.t(14, w: FontWeight.w600, color: AppColors.inkDim)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    FadeSlideIn(
                      index: 5,
                      child: AppCard(
                        margin: EdgeInsets.zero,
                        onTap: () => _reflect(context, s),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const IconTile('pencil', size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(has ? 'Reflection added' : 'Add a reflection',
                                      style: AppText.t(15, w: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(has ? reflection : 'Optional',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.t(13, color: AppColors.muted, lh: 19)),
                                ],
                              ),
                            ),
                            const AppIcon('right', size: 22, color: AppColors.faint),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 20 + Insets.bottom(context)),
              child: PrimaryButton('Back to home', onTap: () {
                s.setTab(0);
                AppNav.popToRoot(context);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
