import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Pill segmented control with a sliding thumb.
class AppSegmented extends StatelessWidget {
  const AppSegmented({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: margin,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: AppColors.segment, borderRadius: BorderRadius.circular(21)),
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: w * index,
                top: 0,
                bottom: 0,
                width: w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Color(0x2B355539), blurRadius: 10, offset: Offset(0, 3)),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: AppText.t(13,
                                w: FontWeight.w600,
                                color: i == index ? Colors.white : AppColors.muted),
                            child: Text(labels[i]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
