import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: Center(
        child: Container(
          width: 400,
          height: 800,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo principal con corona
                Container(
                  width: 250,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Círculo principal con gradiente
                      Container(
                        width: 400,
                        height: 400,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/kingrest.jpg",
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback: emoji feliz con corona
                              return Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '😊',
                                    style: TextStyle(fontSize: 80),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Título "¡Ok Listo!" con gradiente de colores
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFE91E63), // Rosa
                      Color(0xFFFF5722), // Naranja
                      Color(0xFFFF9800), // Amarillo-naranja
                      Color(0xFFFFEB3B), // Amarillo
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    "¡Ok Listo!",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Contenedor del registro emocional
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9ADDFF),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4FC3F7).withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Título del registro
                      const Text(
                        "REGISTRO EMOCIONAL",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF9800),
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              offset: Offset(1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "¡GUARDADO!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Subtítulo "HISTORIAL SEMANAL"
                      const Text(
                        "HISTORIAL SEMANAL",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0277BD),
                          letterSpacing: 1.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Contenedor de días de la semana
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            // Días de la semana
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildDayLabel("LUNES"),
                                _buildDayLabel("MARTES"),
                                _buildDayLabel("MIÉRCOLES"),
                                _buildDayLabel("JUEVES"),
                                _buildDayLabel("VIERNES"),
                                _buildDayLabel("SÁBADO"),
                                _buildDayLabel("DOMINGO"),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // Emojis/Imágenes de estados emocionales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildEmotionIcon("assets/images/sadrest.jpg", "😐"),
                                _buildEmotionIcon("assets/images/goodrest.jpg", "😊"),
                                _buildEmotionIcon("assets/images/yellowrest.jpg", "😄"),
                                _buildEmotionIcon("assets/images/yellowrest.jpg", "😐"),
                                _buildEmotionIcon("assets/images/goodrest.jpg", "😞"),
                                _buildEmotionIcon("assets/images/yellowrest.jpg", "😞"),
                                _buildEmotionIcon("assets/images/goodrest.jpg", "😊"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Botón "LISTO"
                Container(
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF0BBDAC), // centro
                        Color(0xFF6110E8), // bordes
                      ],
                      center: Alignment.center, // desde el centro
                      radius: 3.5, // qué tan rápido se expande el gradiente
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0BBDAC).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: (){
                      Navigator.pushNamed(context, AppRoutes.mainApp);
                    } ,

                    child: Text(
                     "LISTO",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayLabel(String day) {
    return Container(
      width: 30,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 6,
          fontWeight: FontWeight.w600,
          color: Color(0xFF424242),
          letterSpacing: 0.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildEmotionIcon(String imagePath, String fallbackEmoji) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                fallbackEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      ),
    );
  }
}