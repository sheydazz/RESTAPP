import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';

class TrafficLightScreen extends StatelessWidget {
  final String estado; // "excelente", "alerta-amarillo", "alerta-rojo"
  final String mensaje;
  final String botonTexto;
  const TrafficLightScreen({
    super.key,
    required this.estado,
    required this.mensaje,
    required this.botonTexto,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos colores, imagen y configuración según el estado
    Color colorTitulo;
    String titulo;
    String rutaImagen;
    Color colorMensaje;


    switch (estado) {
      case "excelente":
        colorTitulo = const Color(0xFF08D557); // Verde
        colorMensaje = const Color(0xFF41AC20);
        titulo = "¡Excelente!";
        rutaImagen = "assets/images/goodrest.jpg";

        break;
      case "alerta-amarillo":
        colorTitulo = const Color(0xFFFF9800); // Naranja
        colorMensaje = const Color(0xFFFF9800);
        titulo = "¡ALERTA!";
        rutaImagen = "assets/images/yellowrest.jpg";

        break;
      case "alerta-rojo":
        colorTitulo = const Color(0xFFE91E63); // Rosa
        colorMensaje = const Color(0xFFFF0D29);
        titulo = "¡ALERTA!";
        rutaImagen = "assets/images/sadrest.jpg";

        break;
      default:
        colorMensaje = const Color(0xFF41AC20);
        colorTitulo = Colors.grey;
        titulo = "Sin estado";
        rutaImagen = "assets/images/normalrest.jpg";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D), // Fondo gris oscuro
      body: Center(
        child: Container(
          width: 400,
          height: 700,
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
                // Imagen/Carita con gradiente circular
                Container(
                  width: 300,
                  height: 220,
                  child: ClipOval(
                    child: Image.asset(
                      rutaImagen,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // En caso de que no encuentre la imagen, muestra un ícono
                        return Icon(
                          estado == "excelente"
                              ? Icons.sentiment_very_satisfied
                              : estado == "alerta-amarillo"
                              ? Icons.sentiment_neutral
                              : Icons.sentiment_dissatisfied,
                          size: 80,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Título
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,

                    color: colorTitulo,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 24),

                // Contenedor del mensaje
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA8E2FF), // Azul claro
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        mensaje,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorMensaje,
                          height: 1.4,
                        ),
                      ),
                      if (estado != "excelente") ...[
                        const SizedBox(height: 8),
                        const Text(
                          "¡Tenemos esto para ti!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Colors.grey,
                                offset: Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),

                const SizedBox(height: 32),


                // Botón con RadialGradient
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
                      radius: 3.5,
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
                    onPressed: () {
                      switch (estado) {
                        case "excelente":
                          Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.check);
                          break;
                        case "alerta-amarillo":
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.advice,
                            arguments: {
                              "userName": "Mari",
                              "adviceTitle": "Respira y\nRelájate",
                              "message": "Ejercicios de respiración para calmarte..."
                            },
                          );
                          break;
                        case "alerta-rojo":
                          Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.help);
                          break;
                        default:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Estado no reconocido"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      }
                    },

                    child: Text(
                      botonTexto.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
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
}
