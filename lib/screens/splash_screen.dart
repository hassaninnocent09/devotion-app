import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_nav.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import '../widgets/widgets.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AppPhoto('splash'),
          LayoutBuilder(
            builder: (context, box) {
              final top = (box.maxHeight * 0.243).clamp(90.0, 210.0);
              return Column(
                children: [
                  SizedBox(height: top),
                  const AppIcon('leaf', size: 36, color: AppColors.splashLeaf, stroke: 1.5),
                  const SizedBox(height: 33),
                  Text(
                    'Grow closer\nto God, one day\nat a time.',
                    textAlign: TextAlign.center,
                    style: AppText.t(32, color: AppColors.splashInk, lh: 42),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: PrimaryButton(
                      'Get Started',
                      color: const Color(0xFF35563A),
                      onTap: () => AppNav.push(context, const OnboardingScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    // Mock sign-in: there is no backend, so this simply enters the app.
                    onTap: () => context.read<AppState>().completeOnboarding(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                      child: Text('I already have an account',
                          style: AppText.t(13, color: const Color(0xEBFFFFFF), lh: 18)),
                    ),
                  ),
                  SizedBox(height: 30 + Insets.bottom(context)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
