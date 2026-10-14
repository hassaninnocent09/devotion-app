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
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AppPhoto('splash'),
          Padding(
            padding: EdgeInsets.fromLTRB(28, Insets.top(context), 28, Insets.bottom(context) + 28),
            child: Column(
              children: [
                SizedBox(height: h * 0.16),
                const FadeSlideIn(
                  child: AppIcon('leaf', size: 40, color: AppColors.splashLeaf),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  index: 1,
                  child: Text(
                    'Grow closer\nto God, one day\nat a time.',
                    textAlign: TextAlign.center,
                    style: AppText.serif(34, w: FontWeight.w500, color: AppColors.splashInk, lh: 44),
                  ),
                ),
                const Spacer(),
                FadeSlideIn(
                  index: 3,
                  child: PrimaryButton(
                    'Get Started',
                    color: const Color(0xFF35563A),
                    onTap: () => AppNav.push(context, const OnboardingScreen()),
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlideIn(
                  index: 4,
                  child: Pressable(
                    // Mock sign-in: there is no backend, so this simply enters the app.
                    onTap: () => context.read<AppState>().completeOnboarding(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      child: Text('I already have an account',
                          style: AppText.t(14, w: FontWeight.w500, color: const Color(0xEBFFFFFF))),
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
