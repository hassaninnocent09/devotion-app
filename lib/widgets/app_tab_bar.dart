import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_icon.dart';

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

  /// Total height including the system gesture inset (design: 84px).
  static double height(BuildContext c) => 62 + math.max(MediaQuery.paddingOf(c).bottom, 22);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderSoft)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(
                      _items[i].$2,
                      size: 24,
                      filled: i == current,
                      color: i == current ? AppColors.green : AppColors.faint,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _items[i].$1,
                      style: AppText.t(13,
                          w: i == current ? FontWeight.w700 : FontWeight.w500,
                          color: i == current ? AppColors.green : AppColors.faint),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
