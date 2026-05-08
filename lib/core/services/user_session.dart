import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _keyUserName = 'session_user_name';
  static const String _keyAuthToken = 'session_auth_token';
  static const String _keyUserId = 'session_user_id';
  static const String _keyLastTestDate = 'session_last_test_date';

  static String? currentUserName;
  static String? authToken;
  static int? userId;
  static DateTime? lastTestDate; // Fecha del último test completado

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserName = prefs.getString(_keyUserName);
    authToken = prefs.getString(_keyAuthToken);
    userId = prefs.getInt(_keyUserId);

    final lastDateRaw = prefs.getString(_keyLastTestDate);
    if (lastDateRaw != null && lastDateRaw.isNotEmpty) {
      lastTestDate = DateTime.tryParse(lastDateRaw);
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
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyLastTestDate);

    currentUserName = null;
    authToken = null;
    userId = null;
    lastTestDate = null;
  }

  static String get displayName =>
      (currentUserName != null && currentUserName!.trim().isNotEmpty)
      ? currentUserName!
      : 'Usuario';

  /// Verifica si se puede hacer el test hoy (solo una vez al día)
  static bool canDoTestToday() {
    if (lastTestDate == null) return true;
    final today = DateTime.now();
    return lastTestDate!.year != today.year ||
        lastTestDate!.month != today.month ||
        lastTestDate!.day != today.day;
  }
}
