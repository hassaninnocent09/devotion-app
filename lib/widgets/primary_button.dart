import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'motion.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onTap,
    this.height = 54,
    this.color = AppColors.green,
    this.textColor = Colors.white,
  });

  final String label;
  final VoidCallback? onTap;
  final double height;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onTap == null ? color.withAlpha(120) : color,
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: onTap == null
              ? null
              : const [BoxShadow(color: Color(0x33355539), blurRadius: 18, offset: Offset(0, 8))],
        ),
        child: Text(label, style: AppText.t(15, w: FontWeight.w600, color: textColor)),
      ),
    );
  }
}
