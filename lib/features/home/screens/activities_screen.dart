import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0BBDAC),
                            Color(0xFF6110E8),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFF0BBDAC),
                            Color(0xFF6110E8),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          'Mis Actividades',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30), // Para balancear el espacio de la X
                ],
              ),
            ),

            Divider(
              color: Colors.grey[400],
              thickness: 2,
              height: 0,
              indent: 16,
              endIndent: 16,
            ),

            SizedBox(height: 20),

            // Texto motivacional
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Fredoka',
                  ),
                  children: [
                    TextSpan(
                      text: '⭐ ',
                    ),
                    TextSpan(
                      text: 'Realiza las actividades y reclama tus premios personalizados!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Grid de actividades
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(2), // Grosor del borde con gradiente
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0BBDAC),
                        Color(0xFF6110E8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildActivityCard(
                                'Juega un Rato',
                                'assets/images/Play.png',
                                '10/03/2026',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildActivityCard(
                                'Desahógate en\nel Gym',
                                'assets/images/Gym2.png',
                                '10/03/2026',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActivityCard(
                                'Habla con\nuna persona',
                                'assets/images/Talk.png',
                                '10/03/2026',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildActivityCard(
                                'Sal a correr\ncon música',
                                'assets/images/Run.png',
                                '10/03/2026',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActivityCard(
                                'Ayuda a\npersonas',
                                'assets/images/Help.png',
                                '10/03/2026',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildActivityCard(
                                'Diseña un\nVisionBoard',
                                'assets/images/VisionBoard.png',
                                '10/03/2026',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String imagePath, String date) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen de la actividad
              Container(
                width: 80,
                height: 80,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 12),

              // Título de la actividad
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Fecha de vencimiento fuera de la tarjeta
        Text(
          'Vence el:',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}