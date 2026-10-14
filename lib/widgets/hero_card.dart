import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_icon.dart';
import 'app_photo.dart';
import 'glass.dart';
import 'motion.dart';

/// Photo hero card used on Home and Devotionals.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.height,
    required this.eyebrow,
    required this.title,
    required this.meta,
    required this.onTap,
    required this.onLibrary,
    this.completed = false,
    this.ctaLabel = 'Start reading',
  });

  final double height;
  final String eyebrow;
  final String title;
  final String meta;
  final VoidCallback onTap;
  final VoidCallback onLibrary;
  final bool completed;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Pressable(
        onTap: onTap,
        scale: 0.98,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Color(0x3326402B), blurRadius: 28, offset: Offset(0, 14))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const AppPhoto('hills'),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.2, 0.55, 1.0],
                      colors: [Color(0x00233726), Color(0xE0263A2A), Color(0xFF2A4430)],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0x38FFFFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(eyebrow, style: AppText.t(11, w: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 14,
                  child: GlassIconButton(icon: 'library', dark: true, onTap: onLibrary),
                ),
                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 22,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.serif(24, w: FontWeight.w500, color: Colors.white, lh: 32)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const AppIcon('clock', size: 16, color: Color(0xCCFFFFFF)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(meta,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.t(13, color: const Color(0xD9FFFFFF))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: completed
                            ? Container(
                                key: const ValueKey('done'),
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xF2426246),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFE9D24A), shape: BoxShape.circle),
                                      child: const AppIcon('check', size: 17, color: Color(0xFF3B3A18)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('Completed',
                                        style: AppText.t(14, w: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                              )
                            : Container(
                                key: const ValueKey('cta'),
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F5EC),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ctaLabel,
                                        style: AppText.t(14, w: FontWeight.w600, color: AppColors.green)),
                                    const AppIcon('forward', size: 20, color: AppColors.green),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
