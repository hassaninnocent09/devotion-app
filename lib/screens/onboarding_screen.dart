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
      'Short, meaningful devotionals\nthat help you read, reflect and\ngrow in your faith.', 'open-book'),
  _Page('Read the Bible\nyour way.',
      'Explore every book, highlight\nverses and save the ones that\nspeak to you.', 'book'),
  _Page('Build a daily\nrhythm.',
      'Follow reading plans and gentle\nreminders that keep you\nconsistent.', 'plans'),
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
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 4,
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
                    decoration: BoxDecoration(
                      color: i == _index ? AppColors.green : AppColors.onboardDot,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
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
                    child: Column(
                      children: [
                        const SizedBox(height: 68),
                        Text(p.title,
                            textAlign: TextAlign.center, style: AppText.t(27, lh: 40)),
                        const SizedBox(height: 15),
                        Text(p.body,
                            textAlign: TextAlign.center,
                            style: AppText.t(13, color: AppColors.muted, lh: 26)),
                        const SizedBox(height: 45),
                        Container(
                          width: 168,
                          height: 168,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.onboardArt,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: AppIcon(p.icon,
                              size: 84, stroke: 1.2, color: AppColors.onboardArtStroke),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: PrimaryButton(last ? 'Get Started' : 'Next', onTap: _next),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _finish,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 24, 40, 30 + Insets.bottom(context)),
                child: Text('Skip', style: AppText.t(14, color: AppColors.muted, lh: 19)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
