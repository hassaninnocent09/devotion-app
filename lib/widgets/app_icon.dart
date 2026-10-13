import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme.dart';

/// The mockup's own SVG icon set (24px grid, round caps/joins).
/// Rendered as a mask so any [color] can be applied, like `currentColor`.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.color = AppColors.ink,
    this.filled = false,
    this.stroke = 1.7,
  });

  final String name;
  final double size;
  final Color color;
  final bool filled;
  final double stroke;

  static const Map<String, String> _paths = {
    'home': '<path d="M4 11.2 12 4l8 7.2V19a1.2 1.2 0 0 1-1.2 1.2H15v-5.4H9v5.4H5.2A1.2 1.2 0 0 1 4 19z"/>',
    'book': '<path d="M5 4.5A1.5 1.5 0 0 1 6.5 3H18v15H6.5A1.5 1.5 0 0 0 5 19.5z"/><path d="M5 19.5A1.5 1.5 0 0 0 6.5 21H18v-3"/>',
    'plans': '<rect x="4" y="5" width="16" height="15" rx="2"/><path d="M8 3v4M16 3v4M4 10h16"/>',
    'user': '<circle cx="12" cy="8" r="3.6"/><path d="M5 20c0-3.6 3.1-6 7-6s7 2.4 7 6z"/>',
    'right': '<path d="m9 5 7 7-7 7"/>',
    'left': '<path d="m15 5-7 7 7 7"/>',
    'down': '<path d="m6 9 6 6 6-6"/>',
    'search': '<circle cx="11" cy="11" r="6.5"/><path d="m16 16 4 4"/>',
    'bookmark': '<path d="M7 4h10v16l-5-4-5 4z"/>',
    'note': '<path d="M11 5H6a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h11a2 2 0 0 0 2-2v-5"/><path d="m18 3.5 2.5 2.5L12 14.5l-3.5.8.8-3.5z"/>',
    'share': '<path d="M12 15V3m0 0L8 7m4-4 4 4"/><path d="M6 11H5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-8a1 1 0 0 0-1-1h-1"/>',
    'copy': '<rect x="8" y="8" width="12" height="12" rx="2"/><path d="M16 8V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2"/>',
    'pen': '<path d="m15 5 4 4-9.5 9.5L5 19.5l1-4.5z"/><path d="m13 7 4 4"/>',
    'pencil': '<path d="M4 20l1-4L16.5 4.5a2 2 0 0 1 3 3L8 19z"/>',
    'underline': '<path d="M7 4v7a5 5 0 0 0 10 0V4M5 20h14"/>',
    'link': '<path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1"/>',
    'target': '<circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="2.5"/>',
    'check': '<path d="m5 12.5 4.5 4.5L19 7.5"/>',
    'check-circle': '<circle cx="12" cy="12" r="9"/><path d="m8.5 12.3 2.5 2.5 4.5-5"/>',
    'bell': '<path d="M6 16.5V11a6 6 0 0 1 12 0v5.5l1.5 2h-15z"/><path d="M10 21h4"/>',
    'clock': '<circle cx="12" cy="12" r="8.5"/><path d="M12 7.5V12l3 2"/>',
    'history': '<path d="M4 12a8 8 0 1 0 2.5-5.8L4 8.5"/><path d="M4 4v4.5h4.5M12 8v4.5l3 1.5"/>',
    'check-square': '<rect x="4" y="4" width="16" height="16" rx="3"/><path d="m8.5 12 2.5 2.5 4.5-5"/>',
    'settings': '<circle cx="12" cy="12" r="3"/><circle cx="12" cy="12" r="7"/><path d="M12 3v2M12 19v2M3 12h2M19 12h2"/>',
    'leaf': '<path d="M12 21v-8"/><path d="M12 13c0-4 2.5-6.5 7-7 0 4.5-2.5 7-7 7z"/><path d="M12 15c0-3-2-5-6-5.3 0 3.5 2 5.3 6 5.3z"/>',
    'open-book': '<path d="M3 6.5C6 5 9.5 5 12 7c2.5-2 6-2 9-.5V18c-3-1.5-6.5-1.5-9 .5-2.5-2-6-2-9-.5z"/><path d="M12 7v11.5"/>',
    'route': '<circle cx="6" cy="18" r="2"/><circle cx="18" cy="6" r="2"/><path d="M6 16V9a3 3 0 0 1 3-3h7"/>',
  };

  static final Map<String, String> _cache = {};

  String get _svg {
    final key = '$name|$filled|$stroke';
    return _cache.putIfAbsent(key, () {
      final inner = _paths[name] ?? '';
      return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
          '<g fill="${filled ? '#000' : 'none'}" stroke="#000" stroke-width="$stroke" '
          'stroke-linecap="round" stroke-linejoin="round">$inner</g></svg>';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
