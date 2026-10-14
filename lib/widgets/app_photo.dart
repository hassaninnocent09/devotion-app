import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Fills its parent with one of the mockup's SVG illustrations (cover fit).
class AppPhoto extends StatelessWidget {
  const AppPhoto(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/$name.svg', fit: BoxFit.cover, alignment: Alignment.center);
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(child: SizedBox(width: size, height: size, child: const AppPhoto('avatar')));
  }
}
