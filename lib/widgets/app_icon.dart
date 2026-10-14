import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Material (rounded) icon set behind the names used across the app.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.color = AppColors.ink,
    this.filled = false,
    this.stroke = 1.7, // kept for API compatibility; unused
  });

  final String name;
  final double size;
  final Color color;
  final bool filled;
  final double stroke;

  static const Map<String, (IconData, IconData)> _icons = {
    // name: (outlined, filled)
    'home': (Icons.home_outlined, Icons.home_rounded),
    'book': (Icons.menu_book_outlined, Icons.menu_book_rounded),
    'plans': (Icons.calendar_month_outlined, Icons.calendar_month_rounded),
    'user': (Icons.person_outline_rounded, Icons.person_rounded),
    'right': (Icons.chevron_right_rounded, Icons.chevron_right_rounded),
    'left': (Icons.arrow_back_rounded, Icons.arrow_back_rounded),
    'forward': (Icons.arrow_forward_rounded, Icons.arrow_forward_rounded),
    'down': (Icons.keyboard_arrow_down_rounded, Icons.keyboard_arrow_down_rounded),
    'search': (Icons.search_rounded, Icons.search_rounded),
    'close': (Icons.close_rounded, Icons.close_rounded),
    'bookmark': (Icons.bookmark_border_rounded, Icons.bookmark_rounded),
    'note': (Icons.edit_note_rounded, Icons.edit_note_rounded),
    'share': (Icons.ios_share_rounded, Icons.ios_share_rounded),
    'copy': (Icons.content_copy_rounded, Icons.content_copy_rounded),
    'pen': (Icons.border_color_outlined, Icons.border_color_rounded),
    'pencil': (Icons.edit_outlined, Icons.edit_rounded),
    'underline': (Icons.format_underlined_rounded, Icons.format_underlined_rounded),
    'link': (Icons.link_rounded, Icons.link_rounded),
    'focus': (Icons.center_focus_weak_rounded, Icons.center_focus_strong_rounded),
    'library': (Icons.auto_stories_outlined, Icons.auto_stories_rounded),
    'check': (Icons.check_rounded, Icons.check_rounded),
    'check-circle': (Icons.check_circle_outline_rounded, Icons.check_circle_rounded),
    'bell': (Icons.notifications_none_rounded, Icons.notifications_rounded),
    'clock': (Icons.schedule_rounded, Icons.schedule_rounded),
    'history': (Icons.history_rounded, Icons.history_rounded),
    'check-square': (Icons.task_alt_rounded, Icons.task_alt_rounded),
    'settings': (Icons.tune_rounded, Icons.tune_rounded),
    'leaf': (Icons.eco_outlined, Icons.eco_rounded),
    'open-book': (Icons.auto_stories_outlined, Icons.auto_stories_rounded),
    'route': (Icons.route_rounded, Icons.route_rounded),
    'text': (Icons.text_fields_rounded, Icons.text_fields_rounded),
    'logout': (Icons.logout_rounded, Icons.logout_rounded),
    'refresh': (Icons.refresh_rounded, Icons.refresh_rounded),
    'heart': (Icons.favorite_border_rounded, Icons.favorite_rounded),
    'prayer': (Icons.volunteer_activism_outlined, Icons.volunteer_activism_rounded),
    'flag': (Icons.flag_outlined, Icons.flag_rounded),
    'quote': (Icons.format_quote_rounded, Icons.format_quote_rounded),
    'fire': (Icons.local_fire_department_outlined, Icons.local_fire_department_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final pair = _icons[name] ?? (Icons.circle_outlined, Icons.circle);
    return Icon(filled ? pair.$2 : pair.$1, size: size, color: color);
  }
}
