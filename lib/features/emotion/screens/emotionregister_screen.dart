// emotionregister_screen.dart (Preguntas de evaluación emocional)
import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
import 'package:rest/core/services/emotion_service.dart';
import 'package:rest/features/emotion/utils/emotion_calculator.dart';

class EmotionRegisterScreen extends StatefulWidget {
  const EmotionRegisterScreen({super.key});

  @override
  State<EmotionRegisterScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<EmotionRegisterScreen> {
  final EmotionService _emotionService = EmotionService();

  bool _isLoading = true;
  String? _error;
  List<dynamic> _preguntas = [];
  final Map<int, int> _opcionSeleccionadaPorPregunta = {}; // preguntaId -> opcionId

  final List<String> _facesAssets = const [
    'assets/images/sadrest.jpg',
    'assets/images/yellowrest.jpg',
    'assets/images/normalrest.jpg',
    'assets/images/goodrest.jpg',
    'assets/images/smilerest.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final preguntas = await _emotionService.fetchPreguntas();
      setState(() {
        _preguntas = preguntas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _guardarRespuestas() async {
    if (_preguntas.isEmpty) return;

    final respuestas = <Map<String, int>>[];
    for (final q in _preguntas) {
      final int? preguntaId = (q is Map && q['id'] is int) ? q['id'] as int : null;
      if (preguntaId == null) continue;
      final int? opcionId = _opcionSeleccionadaPorPregunta[preguntaId];
      if (opcionId == null) continue;
      respuestas.add({
        'pregunta_id': preguntaId,
        'opcion_id': opcionId,
      });
    }

    if (respuestas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos una respuesta.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _emotionService.enviarRegistroEmocional(respuestas: respuestas);

      if (!mounted) return;
      final resultado = EmotionCalculator.calcularEstado(
        preguntas: _preguntas,
        opcionSeleccionadaPorPregunta: _opcionSeleccionadaPorPregunta,
      );
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.trafficLight,
        arguments: resultado,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo y título
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo igual al del chat
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF7DFDFE),
                          Color(0xFF4ECDC4),
                          Color(0xFF00B4D8),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF4ECDC4), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4ECDC4).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/normalrest.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Título
                  Expanded(
                    child: Text(
                      "¡Cuéntame\nsobre tu día¡",
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 35,
                        height: 0.9,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              Color(0xFF7DFDFE), // Celeste
                              Color(0xFF2196F3), // Azul
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(Rect.fromLTWH(0, 0, 250, 60)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFF2196F3), width: 2),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? _buildErrorContent()
                        : _buildPreguntasContent(),
              ),
            ),

            // Botón guardar
            Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2196F3), // Azul izquierdo
                        Color(0xFF3973D1), // Azul derecho (más oscuro)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                    child: TextButton(
                    onPressed: _isLoading ? null : _guardarRespuestas,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "GUARDAR",
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'No pudimos cargar las preguntas.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _cargarPreguntas,
            child: const Text('Reintentar'),
          )
        ],
      ),
    );
  }

  Widget _buildPreguntasContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: const Text(
            "Test Personal Diario",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Freeman',
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _preguntas.map((q) {
                if (q is! Map) return const SizedBox.shrink();
                final int? id = q['id'] is int ? q['id'] as int : null;
                if (id == null) return const SizedBox.shrink();
                final String textoPregunta =
                    (q['texto'] ?? q['pregunta'] ?? '').toString();
                final List<dynamic> opciones =
                    (q['opciones'] is List) ? q['opciones'] as List : const [];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBDF6FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          textoPregunta,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            fontFamily: 'Freeman',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final int count = opciones.length.clamp(0, _facesAssets.length);
                          final double maxFaceSize = 48;
                          final double spacing = 8;
                          final double borderWidth = 3 * 2;
                          final double paddingSize = 4 * 2;
                          final double available = constraints.maxWidth;
                          final double idealTotal = count * (maxFaceSize + borderWidth + paddingSize) + (count - 1) * spacing;
                          final double faceSize = idealTotal > available
                              ? ((available - (count - 1) * spacing) / count - borderWidth - paddingSize).clamp(24, maxFaceSize)
                              : maxFaceSize;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(count, (index) {
                              final dynamic opcion = opciones[index];
                              final int? opcionId =
                                  (opcion is Map && opcion['id'] is int)
                                      ? opcion['id'] as int
                                      : null;
                              if (opcionId == null) {
                                return const SizedBox.shrink();
                              }
                              final bool seleccionado =
                                  _opcionSeleccionadaPorPregunta[id] == opcionId;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _opcionSeleccionadaPorPregunta[id] =
                                        opcionId;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: seleccionado
                                          ? const Color(0xFFFFC107)
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      _facesAssets[index],
                                      width: faceSize,
                                      height: faceSize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
