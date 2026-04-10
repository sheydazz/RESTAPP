import 'dart:convert';

import 'package:http/http.dart' as http;

import 'user_session.dart';

class EmotionService {
  // Mismo backend que AuthService
  static const String _baseUrl = 'http://190.143.117.179:8080';

  String _formatFechaDdMmYyyy(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$dd-$mm-$yyyy';
  }

  /// Formato YYYY-MM-DD para el endpoint de calendario
  String _formatFechaYyyyMmDd(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$yyyy-$mm-$dd';
  }

  /// Obtiene el calendario con promedio emocional por día.
  /// [inicio] y [fin] en formato YYYY-MM-DD.
  /// Retorna una lista de mapas con fecha y promedio (ej: {"fecha": "2025-03-18", "promedio": 3.2}).
  Future<List<Map<String, dynamic>>> fetchCalendarioEmocional({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final token = UserSession.authToken;
    if (token == null || token.isEmpty) {
      throw Exception('No hay token de autenticación. Inicia sesión de nuevo.');
    }

    final inicioStr = _formatFechaYyyyMmDd(inicio);
    final finStr = _formatFechaYyyyMmDd(fin);
    final uri = Uri.parse(
      '$_baseUrl/api/registro-emocional/calendario?inicio=$inicioStr&fin=$finStr',
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      print('🔄 EmotionService - Respuesta cruda del API: ${response.body}');

      List<Map<String, dynamic>> parseList(List input) {
        return List<Map<String, dynamic>>.from(
          input.map(
            (e) =>
                e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{},
          ),
        );
      }

      if (data is List) {
        return parseList(data);
      }

      if (data is Map && data['data'] is List) {
        return parseList(data['data'] as List);
      }

      // Algunos entornos devuelven data como mapa indexado por fecha.
      if (data is Map && data['data'] is Map) {
        final mapped = <Map<String, dynamic>>[];
        final dataMap = Map<String, dynamic>.from(data['data'] as Map);
        dataMap.forEach((key, value) {
          if (value is Map) {
            final row = Map<String, dynamic>.from(value);
            row.putIfAbsent('fecha', () => key);
            mapped.add(row);
          }
        });
        return mapped;
      }

      return [];
    }
    throw Exception(
      'Error al cargar calendario (${response.statusCode}): ${response.body}',
    );
  }

  Future<List<dynamic>> fetchPreguntas() async {
    final token = UserSession.authToken;
    final uri = Uri.parse('$_baseUrl/api/registro-emocional/preguntas');

    // Intentar con token primero
    http.Response response = await http.get(
      uri,
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    print('PREGUNTAS STATUS → ${response.statusCode}');
    print('PREGUNTAS BODY   → ${response.body}');

    // Si el backend rechaza por rol (403), reintentar SIN token
    if (response.statusCode == 403) {
      print('PREGUNTAS → 403 con token, reintentando sin token...');
      response = await http.get(uri);
      print('PREGUNTAS (sin token) STATUS → ${response.statusCode}');
      print('PREGUNTAS (sin token) BODY   → ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is List) return data;
      if (data is Map && data['data'] is List) return data['data'] as List;
      throw Exception('Formato de preguntas no esperado: ${response.body}');
    } else {
      throw Exception(
        'Error al cargar preguntas (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Retorna `true` si el usuario ya tiene registro emocional en la fecha indicada.
  /// Si el backend responde 404 (no encontrado), retorna `false`.
  Future<bool> existeRegistroEmocionalEnFecha({
    required int usuarioId,
    required DateTime fecha,
  }) async {
    final token = UserSession.authToken;
    if (token == null || token.isEmpty) {
      throw Exception('No hay token de autenticación. Inicia sesión de nuevo.');
    }

    final fechaStr = _formatFechaDdMmYyyy(fecha);
    final uri = Uri.parse(
      '$_baseUrl/api/registro-emocional/usuarios/$usuarioId/fecha/$fechaStr',
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print(
      'EXISTE_REGISTRO → status=${response.statusCode}, body=${response.body}',
    );

    if (response.statusCode == 404) {
      return false;
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = response.body.trim();
      if (body.isEmpty || body == '{}' || body == '[]') {
        return false;
      }
      try {
        final data = jsonDecode(response.body);
        if (data == null) return false;
        if (data is Map && data['existe'] == false) return false;
        // El backend devuelve data.registro_del_dia: false cuando no hay registro
        final inner = data is Map ? data['data'] : null;
        if (inner is Map && inner['registro_del_dia'] == false) {
          return false;
        }
      } catch (_) {}
      return true;
    }

    // Otros errores sí deben reportarse (ej. 401, 500)
    String details = '';
    try {
      details = response.body;
    } catch (_) {}
    throw Exception(
      'Error al validar registro emocional de hoy (status ${response.statusCode}). $details',
    );
  }

  Future<bool> existeRegistroEmocionalHoy() async {
    final userId = UserSession.userId;
    if (userId == null) {
      throw Exception('No se encontró el usuario en sesión.');
    }
    return existeRegistroEmocionalEnFecha(
      usuarioId: userId,
      fecha: DateTime.now(),
    );
  }

  Future<void> enviarRegistroEmocional({
    required List<Map<String, int>> respuestas,
  }) async {
    final token = UserSession.authToken;
    final userId = UserSession.userId;

    if (token == null || token.isEmpty) {
      throw Exception('No hay token de autenticación. Inicia sesión de nuevo.');
    }
    if (userId == null) {
      throw Exception('No se encontró el usuario en sesión.');
    }

    final uri = Uri.parse('$_baseUrl/api/registro-emocional');

    final payload = {'usuario_id': userId, 'respuestas': respuestas};

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al guardar el registro emocional.');
    }
  }
}
