import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_icon.dart';
import 'motion.dart';

/// Standard surface card.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.onTap,
    this.color = AppColors.card,
    this.radius = 22,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0F5A4C28), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: child,
    );
    return onTap == null ? box : Pressable(onTap: onTap, child: box);
  }
}

/// Small uppercase section caption.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.padding = const EdgeInsets.fromLTRB(24, 28, 24, 12), this.trailing});
  final String text;
  final EdgeInsets padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: AppText.t(15, w: FontWeight.w600, lh: 20)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Tinted circular icon tile.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, this.size = 40, this.color = AppColors.green, this.filled = false});
  final String icon;
  final double size;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color.withAlpha(30), shape: BoxShape.circle),
      child: AppIcon(icon, size: size * 0.5, color: color, filled: filled),
    );
  }
}

/// Thin rounded progress bar that animates to its value.
class AnimatedBar extends StatelessWidget {
  const AnimatedBar(this.value, {super.key, this.height = 6});
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0).toDouble()),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => LinearProgressIndicator(
          value: v,
          minHeight: height,
          backgroundColor: AppColors.track,
          valueColor: const AlwaysStoppedAnimation(AppColors.green),
        ),
      ),
    );
  }
}
