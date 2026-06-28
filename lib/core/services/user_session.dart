import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rest/core/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _keyUserName = 'session_user_name';
  static const String _keyAuthToken = 'session_auth_token';
  static const String _keyUserId = 'session_user_id';
  static const String _keyLastTestDate = 'session_last_test_date';
  static const String _keyStreakCount = 'session_streak_count';
  static const String _keyGoalDays = 'session_goal_days';
  static const String _keyLastStreakDate = 'session_last_streak_date';
  static const String _keyStreakGoalSet = 'session_streak_goal_set';
  static const String _keyShowStreakToday = 'session_show_streak_today';

  static String? currentUserName;
  static String? authToken;
  static int? userId;
  static DateTime? lastTestDate;

  // ── Racha ──
  static int streakCount = 0;
  static int goalDays = 7;
  static DateTime? lastStreakDate;
  static bool streakGoalSet = false;
  static bool showStreakToday = false;

  static String get _baseUrl => ApiConfig.baseUrl;

  static Map<String, String> _authHeaders({bool withJson = false}) {
    final token = authToken;
    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa. Inicia sesión nuevamente.');
    }

    return {
      'Authorization': 'Bearer $token',
      if (withJson) 'Content-Type': 'application/json',
    };
  }

  static void _applyStreakPayload(Map<String, dynamic> data) {
    goalDays = (data['goal_days'] as num?)?.toInt() ?? goalDays;
    streakCount = (data['streak_count'] as num?)?.toInt() ?? streakCount;
    streakGoalSet = data['streak_goal_set'] == true;

    final rawDate = data['last_streak_date']?.toString();
    if (rawDate != null && rawDate.isNotEmpty) {
      lastStreakDate = DateTime.tryParse(rawDate);
    }
  }

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserName = prefs.getString(_keyUserName);
    authToken = prefs.getString(_keyAuthToken);
    userId = prefs.getInt(_keyUserId);

    final lastDateRaw = prefs.getString(_keyLastTestDate);
    if (lastDateRaw != null && lastDateRaw.isNotEmpty) {
      lastTestDate = DateTime.tryParse(lastDateRaw);
    }

    streakCount = prefs.getInt(_keyStreakCount) ?? 0;
    goalDays = prefs.getInt(_keyGoalDays) ?? 7;
    streakGoalSet = prefs.getBool(_keyStreakGoalSet) ?? false;
    showStreakToday = prefs.getBool(_keyShowStreakToday) ?? false;

    final lastStreakRaw = prefs.getString(_keyLastStreakDate);
    if (lastStreakRaw != null && lastStreakRaw.isNotEmpty) {
      lastStreakDate = DateTime.tryParse(lastStreakRaw);
    }

    if (authToken != null && authToken!.isNotEmpty) {
      try {
        await syncStreakFromBackend();
      } catch (_) {
        // Si falla backend, mantenemos cache local sin bloquear app
      }
    }
  }

  static Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentUserName != null && currentUserName!.isNotEmpty) {
      await prefs.setString(_keyUserName, currentUserName!);
    }
    if (authToken != null && authToken!.isNotEmpty) {
      await prefs.setString(_keyAuthToken, authToken!);
    }
    if (userId != null) {
      await prefs.setInt(_keyUserId, userId!);
    }
    if (lastTestDate != null) {
      await prefs.setString(_keyLastTestDate, lastTestDate!.toIso8601String());
    }
    await prefs.setInt(_keyStreakCount, streakCount);
    await prefs.setInt(_keyGoalDays, goalDays);
    await prefs.setBool(_keyStreakGoalSet, streakGoalSet);
    await prefs.setBool(_keyShowStreakToday, showStreakToday);
    if (lastStreakDate != null) {
      await prefs.setString(_keyLastStreakDate, lastStreakDate!.toIso8601String());
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyLastTestDate);
    await prefs.remove(_keyStreakCount);
    await prefs.remove(_keyGoalDays);
    await prefs.remove(_keyLastStreakDate);
    await prefs.remove(_keyStreakGoalSet);
    await prefs.remove(_keyShowStreakToday);

    currentUserName = null;
    authToken = null;
    userId = null;
    lastTestDate = null;
    streakCount = 0;
    goalDays = 7;
    lastStreakDate = null;
    streakGoalSet = false;
    showStreakToday = false;
  }

  static Future<void> syncStreakFromBackend() async {
    final uri = Uri.parse('$_baseUrl/api/users/streak-commitment');
    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('No se pudo sincronizar racha (${response.statusCode}): ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map<String, dynamic>
        ? (decoded['data'] is Map<String, dynamic>
              ? decoded['data'] as Map<String, dynamic>
              : decoded)
        : <String, dynamic>{};

    _applyStreakPayload(data);
    await persist();
  }

  static Future<void> saveStreakCommitmentToBackend(int selectedGoalDays) async {
    final uri = Uri.parse('$_baseUrl/api/users/streak-commitment');
    final response = await http.put(
      uri,
      headers: _authHeaders(withJson: true),
      body: jsonEncode({'goal_days': selectedGoalDays}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('No se pudo guardar compromiso de racha (${response.statusCode}): ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map<String, dynamic>
        ? (decoded['data'] is Map<String, dynamic>
              ? decoded['data'] as Map<String, dynamic>
              : decoded)
        : <String, dynamic>{};

    _applyStreakPayload(data);
    await persist();
  }

  static String get displayName =>
      (currentUserName != null && currentUserName!.trim().isNotEmpty)
      ? currentUserName!
      : 'Usuario';

  static bool canDoTestToday() {
    if (lastTestDate == null) return true;
    final today = DateTime.now();
    return lastTestDate!.year != today.year ||
        lastTestDate!.month != today.month ||
        lastTestDate!.day != today.day;
  }

  /// Llama esto justo después de completar el test diario.
  /// Actualiza la racha y marca que debe mostrarse la animación hoy.
  static Future<void> registerDailyCompletion() async {
    if (authToken != null && authToken!.isNotEmpty) {
      try {
        final uri = Uri.parse('$_baseUrl/api/users/streak-commitment/register-daily');
        final response = await http.post(
          uri,
          headers: _authHeaders(withJson: true),
          body: jsonEncode({}),
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('No se pudo registrar racha diaria (${response.statusCode}): ${response.body}');
        }

        final decoded = jsonDecode(response.body);
        final data = decoded is Map<String, dynamic>
            ? (decoded['data'] is Map<String, dynamic>
                  ? decoded['data'] as Map<String, dynamic>
                  : decoded)
            : <String, dynamic>{};

        _applyStreakPayload(data);
        showStreakToday = data['activated_today'] == true;
        await persist();
        return;
      } catch (_) {
        // Si backend falla, seguimos con fallback local
      }
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastStreakDate != null) {
      final last = DateTime(lastStreakDate!.year, lastStreakDate!.month, lastStreakDate!.day);
      final diff = today.difference(last).inDays;
      if (diff == 0) {
        // Ya se registró hoy → no hacer nada
        return;
      } else if (diff == 1) {
        streakCount += 1;
      } else {
        streakCount = 1;
      }
    } else {
      streakCount = 1;
    }

    lastStreakDate = now;
    showStreakToday = true;
    await persist();
  }
}
