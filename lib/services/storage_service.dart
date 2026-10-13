import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the whole app state as one JSON blob.
class StorageService {
  StorageService._(this._prefs);
  static const _key = 'devotion_state_v1';
  final SharedPreferences _prefs;

  static Future<StorageService> open() async =>
      StorageService._(await SharedPreferences.getInstance());

  Map<String, dynamic>? read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> write(Map<String, dynamic> json) => _prefs.setString(_key, jsonEncode(json));
}
