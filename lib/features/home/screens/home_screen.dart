import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_screen.dart';
import 'help_screen.dart';

void main() {
  runApp(HomeScreen());
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Médico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Fredoka',
      ),
      home: MainScreen(),
    );
  }
}
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar Mari
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF87CEEB),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '👋',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Texto "¡Hola! Mari"
                  Text(
                    '¡Hola! Mari',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E86AB),
                    ),
                  ),
                  Spacer(),
                  // Iconos derecha
                  InkWell( // Envuelve el Container con InkWell
                    onTap: () {
                    // Navega a SettingsScreen cuando se presiona el ícono
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                   },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF87CEEB),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  ),
                  SizedBox(width: 8),
                  InkWell( // Envuelve el Container con InkWell
                    onTap: () {
                    // Navega a HelpScreen cuando se presiona el ícono
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpScreen()),
                      );
                   },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF87CEEB),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Botón principal "¿Quieres hablar conmigo?"
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Color(0xFF87CEEB),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  '¿Quieres hablar\nconmigo?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Botón "ESCOGER UN TEMA"
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: Color(0xFF3588CC),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  'ESCOGER UN TEMA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            // Sección "Mis últimas sesiones"
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mis últimas sesiones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E86AB),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Cards de sesiones
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Card Conversaciones
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFF87CEEB),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_2,
                                color: Color(0xFFFFD93D),
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Conversaciones',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.2
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Card Progreso de las Actividad
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF87CEEB),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.emoji_events,
                                color: Color(0xFFFFD93D),
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Progreso de las\nActividad',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Bottom Navigation
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFF2E86AB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                  Icon(
                    Icons.refresh,
                    color: Color(0xFF87CEEB),
                    size: 30,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  }