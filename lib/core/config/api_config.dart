import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConfig {
  // true: usa Docker local
  // false: usa servidor universidad (http://190.143.117.179:8080)
  static const bool useLocalDocker = false;

  // Local host mapping by platform
  // Android emulator: 10.0.2.2 -> host machine
  // iOS simulator/desktop: localhost
  static const String localBaseUrl = 'http://localhost:3000';
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:3000';

  static const String universityBaseUrl = 'http://190.143.117.179:8080';

  static String get baseUrl {
    if (!useLocalDocker) {
      return universityBaseUrl;
    }

    if (kIsWeb) {
      return localBaseUrl;
    }

    if (Platform.isAndroid) {
      return androidEmulatorBaseUrl;
    }

    return localBaseUrl;
  }
}
