import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Pill segmented control (`.seg`).
class AppSegmented extends StatelessWidget {
  const AppSegmented({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.margin = const EdgeInsets.symmetric(horizontal: 24),
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: margin,
      decoration: BoxDecoration(color: AppColors.segment, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    labels[i],
                    style: AppText.t(13,
                        w: FontWeight.w600, color: i == index ? Colors.white : AppColors.muted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Underlined tabs (`.testament`, `.tabs`).
class UnderlineTabs extends StatelessWidget {
  const UnderlineTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    required this.margin,
    this.height = 48,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final EdgeInsets margin;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Text(
                        labels[i],
                        style: AppText.t(13,
                            w: i == index ? FontWeight.w700 : FontWeight.w500,
                            color: i == index ? AppColors.ink : AppColors.muted),
                      ),
                    ),
                    if (i == index)
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: -1,
                        height: 2,
                        child: ColoredBox(color: AppColors.green),
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
