// emotionregister_screen.dart (Preguntas de evaluación emocional)
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
    {"text": "Muy Positivo", "color": Color(0xFFFFC107), "selected": false},
    {"text": "Generalmente Positivo", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Neutral", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Algo Negativo", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Muy Negativo", "color": Color(0xFF87CEEB), "selected": false},
  ];

  final List<Map<String, dynamic>> opcionesDormir = [
    {"text": "No, duermo perfectamente", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Ocasionalmente", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Con cierta frecuencia", "color": Color(0xFFFFC107), "selected": false},
    {"text": "Casi todas las noches", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Todas las noches", "color": Color(0xFF87CEEB), "selected": false},
  ];

  final List<Map<String, dynamic>> concentracionOpciones = [
    {"text": "Sí, sin problemas", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Generalmente sí", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "A veces tengo dificultades", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "Frecuentemente me cuesta", "color": Color(0xFF87CEEB), "selected": false},
    {"text": "No logro concentrarme", "color": Color(0xFF87CEEB), "selected": false},
  ];

  void _guardarRespuestas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrafficLightScreen(
          estado: "excelente", // "excelente", "alerta-amarillo", "alerta-rojo"
          mensaje: "Sigue asi",
          botonTexto: "ok",
        ),
      ),
    );
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
                child: Column(
                  children: [
                    // Título del formulario
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                      ),
                      child: Text(
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
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pregunta 1
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDF6FD),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "¿Cómo describirías tu estado de ánimo general durante la última semana?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900, // Más bold
                                  color: Colors.black87,
                                  fontFamily: 'Freeman',
                                ),
                              ),
                            ),
                            SizedBox(height: 12),

                            // Opciones estado de ánimo
                            ...estadosAnimo.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> opcion = entry.value;
                              bool isSelected = estadoAnimoSelected == index;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      estadoAnimoSelected = index;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFFFFC107) : Color(0xFFBDF6FD),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.grey[400]!, width: 1),
                                          ),
                                          child: isSelected
                                              ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFC107),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                              : null,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          opcion["text"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900, // Más bold
                                            color: Colors.black87,
                                            fontFamily: 'Freeman',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                            SizedBox(height: 16),

                            // Pregunta 2
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDF6FD),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "¿Has experimentado dificultades para dormir en los últimos días?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900, // Más bold
                                  color: Colors.black87,
                                  fontFamily: 'Freeman',
                                ),
                              ),
                            ),
                            SizedBox(height: 12),

                            // Opciones dormir
                            ...opcionesDormir.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> opcion = entry.value;
                              bool isSelected = dificultadesDormirSelected == index;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      dificultadesDormirSelected = index;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFFFFC107) : Color(0xFFBDF6FD),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.grey[400]!, width: 1),
                                          ),
                                          child: isSelected
                                              ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFC107),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                              : null,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          opcion["text"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900, // Más bold
                                            color: Colors.black87,
                                            fontFamily: 'Freeman',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                            SizedBox(height: 16),

                            // Pregunta 3
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDF6FD),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "¿Te has sentido capaz de concentrarte en tus actividades diarias?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900, // Más bold
                                  color: Colors.black87,
                                  fontFamily: 'Freeman',
                                ),
                              ),
                            ),
                            SizedBox(height: 12),

                            // Opciones concentración
                            ...concentracionOpciones.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> opcion = entry.value;
                              bool isSelected = concentracionSelected == index;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      concentracionSelected = index;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFFFFC107) : Color(0xFFBDF6FD),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.grey[400]!, width: 1),
                                          ),
                                          child: isSelected
                                              ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFC107),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                              : null,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          opcion["text"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900, // Más bold
                                            color: Colors.black87,
                                            fontFamily: 'Freeman',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                    onPressed: _guardarRespuestas,
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
}
