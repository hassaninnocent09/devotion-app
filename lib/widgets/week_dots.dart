import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_icon.dart';
import 'motion.dart';

enum DotState { done, part, off }

class DayDot extends StatelessWidget {
  const DayDot(this.state, {super.key});
  final DotState state;

  @override
  Widget build(BuildContext context) {
    final off = state == DotState.off;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: off ? Colors.transparent : (state == DotState.part ? AppColors.dotPart : AppColors.green),
        border: off ? Border.all(color: AppColors.dotOffBorder, width: 1.5) : null,
      ),
      child: AppIcon('check', size: 17, color: off ? AppColors.dotOffCheck : Colors.white),
    );
  }
}

class WeekItem {
  const WeekItem(this.label, this.state, {this.bold = false, this.onTap});
  final String label;
  final DotState state;
  final bool bold;
  final VoidCallback? onTap;
}

class WeekDots extends StatelessWidget {
  const WeekDots({super.key, required this.items});
  final List<WeekItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final it in items)
          Expanded(
            child: Pressable(
              onTap: it.onTap,
              scale: 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DayDot(it.state),
                  const SizedBox(height: 10),
                  Text(
                    it.label,
                    style: AppText.t(12,
                        w: it.bold ? FontWeight.w600 : FontWeight.w500,
                        color: it.bold ? AppColors.ink : AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
