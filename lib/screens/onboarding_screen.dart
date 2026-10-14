import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';

class _Page {
  const _Page(this.title, this.body, this.icon);
  final String title;
  final String body;
  final String icon;
}

const _pages = [
  _Page('Daily devotionals\nfor real life.',
      'Short, meaningful devotionals that help you read, reflect and grow in your faith.', 'open-book'),
  _Page('Read the Bible\nyour way.',
      'Explore every book, highlight verses and save the ones that speak to you.', 'book'),
  _Page('Build a daily\nrhythm.',
      'Follow reading plans and gentle reminders that keep you consistent.', 'plans'),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    context.read<AppState>().completeOnboarding();
    AppNav.popToRoot(context);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _index == _pages.length - 1;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: Insets.top(context)),
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    AppBackButton(onTap: () => Navigator.of(context).maybePop()),
                    const Spacer(),
                    AnimatedOpacity(
                      opacity: last ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Pressable(
                        onTap: last ? null : _finish,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Text('Skip', style: AppText.t(14, w: FontWeight.w500, color: AppColors.muted)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 28),
                        Container(
                          width: 176,
                          height: 176,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF6EEDB), Color(0xFFEFE2C6)],
                            ),
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: AppIcon(p.icon, size: 80, color: AppColors.onboardArtStroke),
                        ),
                        const SizedBox(height: 44),
                        Text(p.title,
                            textAlign: TextAlign.center,
                            style: AppText.serif(30, w: FontWeight.w500, lh: 40)),
                        const SizedBox(height: 16),
                        Text(p.body,
                            textAlign: TextAlign.center,
                            style: AppText.t(14, color: AppColors.muted, lh: 24)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    width: i == _index ? 28 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: i == _index ? AppColors.green : AppColors.onboardDot,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + Insets.bottom(context)),
              child: PrimaryButton(last ? 'Get Started' : 'Next', onTap: _next),
            ),
          ],
        ),
      ),
    );
  }
}
