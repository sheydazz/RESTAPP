/// Utilidad para calcular el estado emocional (4 niveles semáforo) a partir de las respuestas.
/// Las opciones van de 0 (más triste) a 4 (excelente) según el índice en la lista.
class EmotionCalculator {
  /// Estados disponibles (4 niveles)
  static const String CRITICO = 'critico';
  static const String ALERTA_AMARILLO = 'alerta-amarillo';
  static const String NORMAL = 'normal';
  static const String EXCELENTE = 'excelente';

  /// Calcula el estado emocional basado en las respuestas (4 niveles).
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

      final List<dynamic> opciones = (q['opciones'] is List)
          ? q['opciones'] as List
          : [];
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

    // 4 Niveles semáforo: Crítico (Rojo) < 1.0, Amarillo 1.0-2.2, Normal (Azul) 2.2-3.3, Excelente (Verde) >= 3.3
    final Map<String, dynamic> resultado;
    if (promedio >= 3.3) {
      resultado = Map<String, dynamic>.from(_estadoExcelente());
    } else if (promedio >= 2.2) {
      resultado = Map<String, dynamic>.from(_estadoNormal());
    } else if (promedio >= 1.0) {
      resultado = Map<String, dynamic>.from(_estadoAlertaAmarillo());
    } else {
      resultado = Map<String, dynamic>.from(_estadoCritico());
    }
    resultado['promedio'] = promedio;
    print('DEBUG: Resultado final = $resultado');
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
      'estado': EXCELENTE,
      'titulo': '¡Excelente!',
      'mensaje': '¡Qué bien te sientes hoy! Sigue así.',
      'mensaje2': 'Tu energía es inspiradora.',
      'botonTexto': 'Continuar',
    };
  }

  static Map<String, String> _estadoNormal() {
    return {
      'estado': NORMAL,
      'titulo': 'Normal',
      'mensaje': 'Tu día va tranquilo y estable.',
      'mensaje2': 'Es un buen momento para reflexionar.',
      'botonTexto': 'Continuar',
    };
  }

  static Map<String, String> _estadoAlertaAmarillo() {
    return {
      'estado': ALERTA_AMARILLO,
      'titulo': '¡Alerta!',
      'mensaje':
          'Parece que hoy no estás al 100%. Te invitamos a respirar y relajarte.',
      'mensaje2': '¡Tenemos esto para ti!',
      'botonTexto': 'Ver consejos',
    };
  }

  static Map<String, String> _estadoCritico() {
    return {
      'estado': CRITICO,
      'titulo': '¡Alerta!',
      'mensaje': 'Notamos que hoy te sientes mal. Estamos aquí para ayudarte.',
      'mensaje2': '¡Tenemos esto para ti!',
      'botonTexto': 'Pedir ayuda',
    };
  }

  static Map<String, dynamic> _defaultExcelente() {
    final r = Map<String, dynamic>.from(_estadoExcelente());
    r['promedio'] = 4.0;
    return r;
  }
}
