// emotionregister_screen.dart (Versión mejorada con diseño amigable)
import 'package:flutter/material.dart';
import 'package:rest/features/emotion/screens/traffic_light_screen.dart';

class EmotionRegisterScreen extends StatefulWidget {
  const EmotionRegisterScreen({super.key});

  @override
  State<EmotionRegisterScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<EmotionRegisterScreen> {
  int? estadoAnimoSelected;
  int? dificultadesDormirSelected;
  int? concentracionSelected;

  final List<Map<String, dynamic>> estadosAnimo = [
    {
      "text": "Muy Positivo",
      "emoji": "😄",
      "color": Color(0xFF4CAF50), // Verde
      "icon": Icons.sentiment_very_satisfied,
    },
    {
      "text": "Generalmente Positivo",
      "emoji": "🙂",
      "color": Color(0xFF8BC34A), // Verde claro
      "icon": Icons.sentiment_satisfied,
    },
    {
      "text": "Neutral",
      "emoji": "😐",
      "color": Color(0xFFFFB74D), // Naranja suave
      "icon": Icons.sentiment_neutral,
    },
    {
      "text": "Algo Negativo",
      "emoji": "😟",
      "color": Color(0xFFFF9800), // Naranja
      "icon": Icons.sentiment_dissatisfied,
    },
    {
      "text": "Muy Negativo",
      "emoji": "😢",
      "color": Color(0xFFF44336), // Rojo
      "icon": Icons.sentiment_very_dissatisfied,
    },
  ];

  final List<Map<String, dynamic>> opcionesDormir = [
    {
      "text": "No, duermo perfectamente",
      "emoji": "😴",
      "color": Color(0xFF4CAF50), // Verde
      "icon": Icons.bedtime,
    },
    {
      "text": "Ocasionalmente",
      "emoji": "😪",
      "color": Color(0xFF8BC34A), // Verde claro
      "icon": Icons.nights_stay,
    },
    {
      "text": "Con cierta frecuencia",
      "emoji": "😓",
      "color": Color(0xFFFFB74D), // Naranja suave
      "icon": Icons.dark_mode,
    },
    {
      "text": "Casi todas las noches",
      "emoji": "😫",
      "color": Color(0xFFFF9800), // Naranja
      "icon": Icons.mode_night,
    },
    {
      "text": "Todas las noches",
      "emoji": "😩",
      "color": Color(0xFFF44336), // Rojo
      "icon": Icons.nightlight_round,
    },
  ];

  final List<Map<String, dynamic>> concentracionOpciones = [
    {
      "text": "Sí, sin problemas",
      "emoji": "🎯",
      "color": Color(0xFF4CAF50), // Verde
      "icon": Icons.psychology,
    },
    {
      "text": "Generalmente sí",
      "emoji": "👍",
      "color": Color(0xFF8BC34A), // Verde claro
      "icon": Icons.thumb_up,
    },
    {
      "text": "A veces tengo dificultades",
      "emoji": "🤔",
      "color": Color(0xFFFFB74D), // Naranja suave
      "icon": Icons.help_outline,
    },
    {
      "text": "Frecuentemente me cuesta",
      "emoji": "😵",
      "color": Color(0xFFFF9800), // Naranja
      "icon": Icons.blur_on,
    },
    {
      "text": "No logro concentrarme",
      "emoji": "🌀",
      "color": Color(0xFFF44336), // Rojo
      "icon": Icons.crisis_alert,
    },
  ];

  void _guardarRespuestas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrafficLightScreen(
          estado: "excelente",
          mensaje: "Sigue asi",
          botonTexto: "ok",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF), // Fondo suave azul claro
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo y título
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 70,
                    height: 70,
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
                      border: Border.all(color: Color(0xFF4ECDC4), width: 3),
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
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Título
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "¡Cuéntame",
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 28,
                            height: 1.0,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Color(0xFF7DFDFE),
                                  Color(0xFF2196F3),
                                ],
                              ).createShader(Rect.fromLTWH(0, 0, 200, 30)),
                          ),
                        ),
                        Text(
                          "sobre tu día!",
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 28,
                            height: 1.0,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Color(0xFF7DFDFE),
                                  Color(0xFF2196F3),
                                ],
                              ).createShader(Rect.fromLTWH(0, 0, 200, 30)),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Test Personal Diario",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'Freeman',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 16),

                    // Card - Pregunta 1: Estado de ánimo
                    _buildQuestionCard(
                      icon: Icons.favorite,
                      iconColor: Color(0xFFE91E63),
                      title: "¿Cómo te has sentido?",
                      subtitle: "Tu estado de ánimo durante la última semana",
                      options: estadosAnimo,
                      selectedIndex: estadoAnimoSelected,
                      onSelect: (index) {
                        setState(() {
                          estadoAnimoSelected = index;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Card - Pregunta 2: Sueño
                    _buildQuestionCard(
                      icon: Icons.hotel,
                      iconColor: Color(0xFF673AB7),
                      title: "¿Cómo has dormido?",
                      subtitle: "Dificultades para dormir en los últimos días",
                      options: opcionesDormir,
                      selectedIndex: dificultadesDormirSelected,
                      onSelect: (index) {
                        setState(() {
                          dificultadesDormirSelected = index;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Card - Pregunta 3: Concentración
                    _buildQuestionCard(
                      icon: Icons.lightbulb,
                      iconColor: Color(0xFFFF9800),
                      title: "¿Puedes concentrarte?",
                      subtitle: "Tu capacidad en actividades diarias",
                      options: concentracionOpciones,
                      selectedIndex: concentracionSelected,
                      onSelect: (index) {
                        setState(() {
                          concentracionSelected = index;
                        });
                      },
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Botón guardar
            Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: InkWell( // ⬅️ Utilizamos InkWell para manejar el 'tap'
                  onTap: (estadoAnimoSelected != null &&
                      dificultadesDormirSelected != null &&
                      concentracionSelected != null)
                      ? _guardarRespuestas
                      : null, // Si es nulo, el botón está deshabilitado
                  borderRadius: BorderRadius.circular(32), // Para que el efecto de 'tap' coincida
                  child: Container( // ⬅️ Este Container contiene el diseño (Degradado y Texto)
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Mayor padding vertical para mejor área de clic
                    decoration: BoxDecoration(
                      // ⬅️ El Degradado se aplica directamente al Container
                      gradient: LinearGradient(
                        colors: (estadoAnimoSelected != null &&
                            dificultadesDormirSelected != null &&
                            concentracionSelected != null)
                            ? [
                          Color(0xFF2196F3), // Azul izquierdo
                          Color(0xFF3973D1), // Azul derecho (más oscuro)
                        ]
                            : [ // ⬅️ Colores cuando el botón está deshabilitado (opcional)
                          Colors.grey[400]!,
                          Colors.grey[600]!,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text( // ⬅️ El Texto es el hijo directo del Container
                      "GUARDAR",
                      textAlign: TextAlign.center,
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Map<String, dynamic>> options,
    required int? selectedIndex,
    required Function(int) onSelect,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de la pregunta
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.1),
                  iconColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Freeman',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontFamily: 'Freeman',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Opciones
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: options.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> opcion = entry.value;
                bool isSelected = selectedIndex == index;

                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelect(index),
                      borderRadius: BorderRadius.circular(15),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [
                              opcion["color"],
                              opcion["color"].withOpacity(0.8),
                            ],
                          )
                              : null,
                          color: isSelected ? null : Color(0xFFF5F9FF),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? opcion["color"]
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              // Emoji/Icono
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.3)
                                      : opcion["color"].withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    opcion["emoji"],
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),

                              // Texto
                              Expanded(
                                child: Text(
                                  opcion["text"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontFamily: 'Freeman',
                                  ),
                                ),
                              ),

                              // Check indicator
                              if (isSelected)
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: opcion["color"],
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}