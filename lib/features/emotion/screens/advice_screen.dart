import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
class AdviceScreen extends StatelessWidget {
  final String userName;
  final String adviceTitle;
  final String message;

  const AdviceScreen({
    Key? key,
    required this.userName,
    required this.adviceTitle,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header con cara y saludo
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Cara (imagen de assets)
                    Container(
                      width: 100,
                      height: 100,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.multiply,
                        ),
                        child: Image.asset(
                          'assets/images/yellowrest.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultFace(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Saludo
                    Expanded(
                      child: Text(
                        '¡Hola! $userName',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 2,
                color: const Color(0xFF3B28EC),
              ),
              const SizedBox(height: 30),

              // Título principal (dinámico)
              Container(
                width: 300,
                height: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal:10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  adviceTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Contenido del mensaje
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF9C27B0),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Botón LISTO
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
                    Navigator.pushNamed(context, AppRoutes.mainApp);
                  },
                  child: Text(
                "LISTO",
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
    );
  }

  Widget _buildDefaultFace() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFF66BB6A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(child: Text('😊', style: TextStyle(fontSize: 30))),
    );
  }
}
