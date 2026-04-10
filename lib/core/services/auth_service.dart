import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rest/core/config/api_config.dart';

class AuthService {
  static String get _baseUrl => ApiConfig.baseUrl;

  Future<Map<String, dynamic>> login({
    required String correo,
    required String contrasena,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/auth/login');

    final payload = {
      'correo': correo.toLowerCase().trim(),
      'contrasena': contrasena,
    };

    print('LOGIN REQUEST → $uri');
    print('LOGIN BODY    → $payload');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print('LOGIN RESPONSE STATUS → ${response.statusCode}');
    print('LOGIN RESPONSE BODY   → ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    } else {
      String message = 'Error al iniciar sesión';
      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          message = data['message'].toString();
        }
        if (data['errors'] != null) {
          message = '$message: ${data['errors']}';
        }
      }
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> register({
    required String correo,
    required String contrasena,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String ciudad,
    required int edad,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/auth/register');

    final payload = {
      'correo': correo.toLowerCase().trim(),
      'contrasena': contrasena,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'ciudad': ciudad,
      'edad': edad,
    };

    print('REGISTER REQUEST → $uri');
    print('REGISTER BODY    → $payload');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print('REGISTER RESPONSE STATUS → ${response.statusCode}');
    print('REGISTER RESPONSE BODY   → ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    } else {
      String message = 'Error al registrarse';
      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          message = data['message'].toString();
        }
        if (data['errors'] != null) {
          message = '$message: ${data['errors']}';
        }
      }
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> recoverPassword({
    required String correo,
    required String nuevaContrasena,
    required String confirmarContrasena,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/auth/recover-password');

    final payload = {
      'correo': correo.toLowerCase().trim(),
      'nuevaContrasena': nuevaContrasena,
      'confirmarContrasena': confirmarContrasena,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    }

    String message = 'Error al recuperar contraseña';
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'].toString();
      }
      if (data['errors'] != null) {
        message = '$message: ${data['errors']}';
      }
    }
    throw Exception(message);
  }
}
