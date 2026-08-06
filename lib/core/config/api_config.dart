import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Local host mapping by platform
  // Android emulator: 10.0.2.2 -> host machine
  // iOS simulator/desktop: localhost
  static const String localBaseUrl = 'http://localhost:3000';
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:3000';

  static const String universityBaseUrl = 'http://179.197.239.216:3000';

  static String get baseUrl {
    // debug/profile (flutter run) -> servidor local; release (flutter build) -> servidor universidad
    if (kReleaseMode) {
      return universityBaseUrl;
    }

    if (kIsWeb) {
      final host = Uri.base.host;
      final scheme = Uri.base.scheme.isEmpty ? 'http' : Uri.base.scheme;
      if (host.isEmpty) {
        return localBaseUrl;
      }
      return '$scheme://$host:3000';
    }

    if (Platform.isAndroid) {
      return androidEmulatorBaseUrl;
    }

    return localBaseUrl;
  }
}
