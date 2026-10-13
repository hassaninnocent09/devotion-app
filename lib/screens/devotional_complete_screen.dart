import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';

/// Screen 10 – Devotional completed.
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
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).maybePop(),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(28, 30, 40, 10),
                  child: AppIcon('left', size: 18),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 68,
                      height: 68,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.seal,
                        shape: BoxShape.circle,
                      ),
                      child: const AppIcon('check', size: 30, stroke: 2, color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    Text('Today’s devotional\nis complete!',
                        textAlign: TextAlign.center, style: AppText.t(26, lh: 48)),
                    const SizedBox(height: 17),
                    Text('You’ve taken an important step\nin your spiritual journey.',
                        textAlign: TextAlign.center,
                        style: AppText.t(13, color: AppColors.muted, lh: 26)),
                    const SizedBox(height: 56),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Material(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _reflect(context, s),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 88),
                            padding: const EdgeInsets.fromLTRB(26, 19, 24, 19),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: AppIcon('pencil', size: 18, color: AppColors.inkDim),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(has ? 'Reflection added' : 'Add a reflection',
                                          style: AppText.t(14, w: FontWeight.w600, lh: 18)),
                                      const SizedBox(height: 11),
                                      Text(has ? reflection : '(Optional)',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppText.t(13, color: AppColors.muted, lh: 18)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 32 + Insets.bottom(context)),
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
