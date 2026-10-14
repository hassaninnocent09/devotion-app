import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import 'app_icon.dart';
import 'glass.dart';
import 'motion.dart';

/// Frosted bottom navigation with an animated selection pill.
class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.current, required this.onTap});

  final int current;
  final ValueChanged<int> onTap;

  static const _items = [
    ('Home', 'home'),
    ('Bible', 'book'),
    ('Plans', 'plans'),
    ('You', 'user'),
  ];

  static double height(BuildContext c) => 64 + Insets.bottom(c);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context),
      child: Stack(
        children: [
          const Positioned.fill(child: GlassBackdrop(borderTop: true, sigma: 24, tint: Color(0xD1F9F5EC))),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, Insets.bottom(context)),
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: Pressable(
                      onTap: () => onTap(i),
                      scale: 0.92,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            width: i == current ? 60 : 36,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: i == current ? const Color(0x1F355539) : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: AppIcon(
                                _items[i].$2,
                                key: ValueKey('${_items[i].$2}${i == current}'),
                                size: 24,
                                filled: i == current,
                                color: i == current ? AppColors.green : AppColors.muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _items[i].$1,
                            style: AppText.t(12,
                                w: i == current ? FontWeight.w600 : FontWeight.w500,
                                color: i == current ? AppColors.green : AppColors.muted),
                          ),
                        ],
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
