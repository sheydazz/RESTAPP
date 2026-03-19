/// Utilidad para calcular el estado emocional (semáforo) a partir de las respuestas.
/// Las opciones van de 0 (más triste) a 4 (excelente) según el índice en la lista.
class EmotionCalculator {
  /// Calcula el estado emocional basado en las respuestas.
  /// [preguntas] lista de preguntas con opciones.
  /// [opcionSeleccionadaPorPregunta] mapa preguntaId -> opcionId.
  /// Retorna un mapa con: estado, mensaje, botonTexto, promedio (0-4).
  static Map<String, dynamic> calcularEstado({
    required List<dynamic> preguntas,
    required Map<int, int> opcionSeleccionadaPorPregunta,
  }) {
    if (preguntas.isEmpty) {
      return _defaultExcelente();
    }

    double sumaValores = 0;
    int cantidad = 0;

    for (final q in preguntas) {
      if (q is! Map) continue;
      final int? preguntaId = (q['id'] is int) ? q['id'] as int : null;
      if (preguntaId == null) continue;

      final int? opcionId = opcionSeleccionadaPorPregunta[preguntaId];
      if (opcionId == null) continue;

      final List<dynamic> opciones =
          (q['opciones'] is List) ? q['opciones'] as List : [];
      final int indice = _indiceDeOpcion(opciones, opcionId);
      if (indice >= 0) {
        sumaValores += indice;
        cantidad++;
      }
    }

    if (cantidad == 0) {
      return _defaultExcelente();
    }

    final promedio = sumaValores / cantidad;

    // Umbrales: 0-4 escala (0=triste, 4=excelente)
    // excelente: >= 3.5
    // alerta-amarillo: >= 1.5 y < 3.5
    // alerta-rojo: < 1.5
    final Map<String, dynamic> resultado;
    if (promedio >= 3.5) {
      resultado = Map<String, dynamic>.from(_estadoExcelente());
    } else if (promedio >= 1.5) {
      resultado = Map<String, dynamic>.from(_estadoAlertaAmarillo());
    } else {
      resultado = Map<String, dynamic>.from(_estadoAlertaRojo());
    }
    resultado['promedio'] = promedio;
    return resultado;
  }

  static int _indiceDeOpcion(List<dynamic> opciones, int opcionId) {
    for (int i = 0; i < opciones.length; i++) {
      final op = opciones[i];
      if (op is Map && op['id'] == opcionId) return i;
    }
    return -1;
  }

  static Map<String, String> _estadoExcelente() {
    return {
      'estado': 'excelente',
      'mensaje': '¡Qué bien te sientes hoy! Sigue así.',
      'botonTexto': 'Continuar',
    };
  }

  static Map<String, String> _estadoAlertaAmarillo() {
    return {
      'estado': 'alerta-amarillo',
      'mensaje': 'Parece que hoy no estás al 100%. Te invitamos a respirar y relajarte un poco.',
      'botonTexto': 'Ver consejos',
    };
  }

  static Map<String, String> _estadoAlertaRojo() {
    return {
      'estado': 'alerta-rojo',
      'mensaje': 'Notamos que hoy te sientes mal. Estamos aquí para ayudarte.',
      'botonTexto': 'Pedir ayuda',
    };
  }

  static Map<String, dynamic> _defaultExcelente() {
    final r = Map<String, dynamic>.from(_estadoExcelente());
    r['promedio'] = 4.0;
    return r;
  }
}
