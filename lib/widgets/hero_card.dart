import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_icon.dart';
import 'app_photo.dart';

/// Photo hero card used on Home and Devotionals.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.height,
    required this.eyebrow,
    required this.title,
    required this.minutes,
    required this.onTap,
    required this.onTarget,
    this.caps = false,
    this.completed = false,
    this.ctaLabel = 'Start reading',
  });

  final double height;
  final String eyebrow;
  final String title;
  final int minutes;
  final VoidCallback onTap;
  final VoidCallback onTarget;
  final bool caps;
  final bool completed;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AppPhoto('hills'),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.22, 0.56, 1.0],
                  colors: [Color(0x00233726), Color(0xE6263A2A), Color(0xFF2F4A34)],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: IgnorePointer(
                    child: Text(
                      eyebrow,
                      style: caps
                          ? AppText.t(10, w: FontWeight.w600, color: AppColors.gold, lh: 18, ls: 0.8)
                          : AppText.t(13, w: FontWeight.w500, color: const Color(0xC7FFFFFF), lh: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 15, 22, 0),
                  child: IgnorePointer(
                    child: Text(title, style: AppText.t(22, color: Colors.white, lh: 32)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 11, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IgnorePointer(
                        child: Text('$minutes min read',
                            style: AppText.t(13, color: const Color(0xD1FFFFFF), lh: 18)),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTarget,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(14, 4, 6, 4),
                          child: AppIcon('target', size: 13, color: Color(0xD1FFFFFF)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (completed)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 25, 16, 22),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTap,
                      child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xF2426246),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE9D24A),
                              shape: BoxShape.circle,
                            ),
                            child: const AppIcon('check',
                                size: 14, stroke: 2.4, color: Color(0xFF3B3A18)),
                          ),
                          const SizedBox(width: 10),
                          Text('Completed',
                              style: AppText.t(13, w: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 23, 22, 22),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTap,
                      child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xEB426448),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0x14FFFFFF)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ctaLabel,
                              style: AppText.t(13, w: FontWeight.w600, color: Colors.white)),
                          const AppIcon('right', size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
