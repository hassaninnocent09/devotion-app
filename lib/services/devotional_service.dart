import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/devotional.dart';

/// Loads the bundled devotional series (assets/data/devotions.json).
/// Swap the body for an API call to serve devotions remotely.
class DevotionalService {
  Future<DevotionalSeries> load() async {
    final raw = await rootBundle.loadString('assets/data/devotions.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final meta = json['app_content'] as Map<String, dynamic>;
    final items = (json['devotions'] as List)
        .map((e) => Devotional.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    return DevotionalSeries(
      title: meta['title'] as String,
      description: meta['description'] as String,
      totalDays: meta['duration_days'] as int? ?? items.length,
      items: items,
    );
  }
}
