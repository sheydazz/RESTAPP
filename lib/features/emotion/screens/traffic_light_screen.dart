import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
import '../../../core/services/user_session.dart';
import '../utils/emotion_state_config.dart';

class TrafficLightScreen extends StatelessWidget {
  final String estado;
  final String mensaje;
  final String botonTexto;
  final double?
  promedioHoy; // Para pasar a CheckScreen y mostrar la carita del día
  const TrafficLightScreen({
    super.key,
    required this.estado,
    required this.mensaje,
    required this.botonTexto,
    this.promedioHoy,
  });

  @override
  Widget build(BuildContext context) {
    // DEBUG: Ver qué parámetro recibimos
    print('🔴 TrafficLightScreen recibió estado: "$estado"');
    print(
      '🔴 TrafficLightScreen resultado completo: estado=$estado, mensaje=$mensaje, botonTexto=$botonTexto, promedio=$promedioHoy',
    );

    final config = EmotionStateConfig.getConfig(estado);
    final recomendaciones = config.getRandomRecommendations(count: 3);

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
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circulo decorativo de fondo
                  Container(
                    width: 280,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          config.colorPrincipal.withOpacity(0.15),
                          config.colorPrincipal.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          config.imagenAsset,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.sentiment_satisfied,
                              size: 100,
                              color: config.colorPrincipal,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Título dinámico con color según estado
                  Text(
                    config.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: config.colorPrincipal,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Contenedor del mensaje principal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: config.colorPrincipal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: config.colorPrincipal.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          config.mensaje,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: config.colorTexto,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          config.mensaje2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: config.colorTexto.withOpacity(0.8),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recomendaciones quick tips
                  if (estado != 'excelente' && recomendaciones.isNotEmpty) ...[
                    Text(
                      'Sugerencias de bienestar:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: recomendaciones
                            .map(
                              (rec) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  rec,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Botón de acción
                  Container(
                    width: 220,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        colors: [config.colorPrincipal, config.colorSecundario],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: config.colorPrincipal.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
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
                      onPressed: () {
                        // TODAS las rutas van a CheckScreen (Registro Guardado)
                        if (estado == 'alerta-amarillo' ||
                            estado == 'critico') {
                          // Primero mostrar consejos, luego ir a registro guardado
                          Navigator.of(context).pushNamed(
                            AppRoutes.advice,
                            arguments: {
                              'estado': estado,
                              'userName': UserSession.displayName,
                            },
                          );
                        } else {
                          // Estados buenos van directo a registro guardado
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.check,
                            arguments: {'promedioHoy': promedioHoy},
                          );
                        }
                      },
                      child: Text(
                        config.botonTexto,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
