class UserSession {
  static String? currentUserName;
  static String? authToken;
  static int? userId;

  static String get displayName =>
      (currentUserName != null && currentUserName!.trim().isNotEmpty)
          ? currentUserName!
          : 'Usuario';
}

