import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisteredUser {
  const RegisteredUser({
    required this.phone,
    required this.fullName,
  });

  final String phone;
  final String fullName;

  Map<String, String> toJson() => {
        'phone': phone,
        'fullName': fullName,
      };

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      phone: UserAuthService.normalizePhone(json['phone'] as String),
      fullName: json['fullName'] as String,
    );
  }
}

abstract final class UserAuthService {
  static const _usersKey = 'registered_users';
  static const _sessionKey = 'logged_in_phone';

  static final List<RegisteredUser> _memoryUsers = [];
  static String? _memorySession;

  static String normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 10) return digits;
    return digits.substring(digits.length - 10);
  }

  static Future<SharedPreferences?> _tryPrefs() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e, stack) {
      debugPrint('UserAuthService: SharedPreferences unavailable: $e');
      debugPrint('$stack');
      return null;
    }
  }

  /// Merge memory + disk so a successful register is never lost.
  static Future<List<RegisteredUser>> syncUsers() async {
    final merged = <String, RegisteredUser>{};

    for (final user in _memoryUsers) {
      merged[user.phone] = user;
    }

    final prefs = await _tryPrefs();
    if (prefs != null) {
      try {
        final raw = prefs.getString(_usersKey);
        if (raw != null && raw.isNotEmpty) {
          final list = jsonDecode(raw) as List<dynamic>;
          for (final item in list) {
            final user =
                RegisteredUser.fromJson(item as Map<String, dynamic>);
            merged[user.phone] = user;
          }
        }
      } catch (e) {
        debugPrint('UserAuthService: failed to read users: $e');
      }
    }

    final users = merged.values.toList()
      ..sort((a, b) => a.phone.compareTo(b.phone));

    _memoryUsers
      ..clear()
      ..addAll(users);

    return List.unmodifiable(users);
  }

  static Future<void> _persistUsers(List<RegisteredUser> users) async {
    _memoryUsers
      ..clear()
      ..addAll(users);

    final prefs = await _tryPrefs();
    if (prefs == null) {
      debugPrint(
        'UserAuthService: saved ${users.length} user(s) in memory only',
      );
      return;
    }

    try {
      final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
      final saved = await prefs.setString(_usersKey, encoded);
      debugPrint(
        'UserAuthService: persisted ${users.length} user(s), ok=$saved',
      );
    } catch (e) {
      debugPrint('UserAuthService: failed to persist users: $e');
    }
  }

  static Future<bool> hasRegisteredUsers() async {
    final users = await syncUsers();
    return users.isNotEmpty;
  }

  static Future<bool> isRegistered(String phone) async {
    final normalized = normalizePhone(phone);
    final users = await syncUsers();
    return users.any((u) => u.phone == normalized);
  }

  static Future<RegisteredUser?> findUser(String phone) async {
    final normalized = normalizePhone(phone);
    final users = await syncUsers();
    for (final user in users) {
      if (user.phone == normalized) return user;
    }
    return null;
  }

  static Future<void> registerUser({
    required String phone,
    required String fullName,
  }) async {
    final normalized = normalizePhone(phone);
    final users = (await syncUsers()).toList();
    final index = users.indexWhere((u) => u.phone == normalized);

    final entry = RegisteredUser(
      phone: normalized,
      fullName: fullName.trim(),
    );

    if (index >= 0) {
      users[index] = entry;
    } else {
      users.add(entry);
    }

    await _persistUsers(users);

    final verified = await isRegistered(normalized);
    if (!verified) {
      _memoryUsers.add(entry);
      await _persistUsers(_memoryUsers.toList());
    }
  }

  static Future<String?> getLoggedInPhone() async {
    try {
      final prefs = await _tryPrefs();
      if (prefs == null) return _memorySession;
      final stored = prefs.getString(_sessionKey);
      return stored != null ? normalizePhone(stored) : _memorySession;
    } catch (e) {
      debugPrint('UserAuthService: getLoggedInPhone error: $e');
      return _memorySession;
    }
  }

  static Future<void> saveSession(String phone) async {
    _memorySession = normalizePhone(phone);

    final prefs = await _tryPrefs();
    if (prefs == null) return;

    try {
      await prefs.setString(_sessionKey, _memorySession!);
    } catch (e) {
      debugPrint('UserAuthService: saveSession error: $e');
    }
  }

  @visibleForTesting
  static Future<void> resetForTest() async {
    _memoryUsers.clear();
    _memorySession = null;
    final prefs = await _tryPrefs();
    await prefs?.clear();
  }

  static Future<void> clearSession() async {
    _memorySession = null;

    final prefs = await _tryPrefs();
    if (prefs == null) return;

    try {
      await prefs.remove(_sessionKey);
    } catch (e) {
      debugPrint('UserAuthService: clearSession error: $e');
    }
  }
}
