// lib/core/services/recent_locations_store.dart

import 'dart:convert';

import 'package:krishix/core/data/app_locations.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class RecentLocationsStore {
  static const _key = 'recent_locations_v1';
  static const _maxItems = 8;

  static Future<List<AppLocation>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_key);
      if (raw == null) return [];
      return raw
          .map((s) {
            try {
              return AppLocation.fromJson(
                jsonDecode(s) as Map<String, dynamic>,
              );
            } catch (_) {
              return null;
            }
          })
          .whereType<AppLocation>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(AppLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await load();
      final updated = [
        location,
        ...existing.where(
          (l) => l.full.toLowerCase() != location.full.toLowerCase(),
        ),
      ].take(_maxItems).toList();

      await prefs.setStringList(
        _key,
        updated.map((l) => jsonEncode(l.toJson())).toList(),
      );
    } catch (_) {
      // Non-critical — ignore storage errors.
    }
  }
}
