class UserSession {
  static String? currentUserName;
  static String? authToken;
  static int? userId;
  static DateTime? lastTestDate; // Fecha del último test completado

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
