class ApiConfig {
  // true: usa Docker local (http://localhost:3000)
  // false: usa servidor universidad (http://190.143.117.179:8080)
  static const bool useLocalDocker = false;

  static const String localBaseUrl = 'http://localhost:3000';
  static const String universityBaseUrl = 'http://190.143.117.179:8080';

  static String get baseUrl =>
      useLocalDocker ? localBaseUrl : universityBaseUrl;
}
