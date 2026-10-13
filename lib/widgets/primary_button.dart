import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onTap,
    this.height = 50,
    this.color = AppColors.green,
  });

  final String label;
  final VoidCallback? onTap;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);
    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Center(
            child: Text(label, style: AppText.t(14, w: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
