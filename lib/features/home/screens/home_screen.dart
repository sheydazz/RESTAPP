import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../settings/screens/settings_screen.dart';
import 'help_screen.dart';
import 'package:rest/features/emotion/screens/chat_screen.dart';

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
                    width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF87CEEB),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/normalrest.jpg'),
                        fit: BoxFit.cover,
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
                  InkWell(
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
                      child: Padding(
                        padding: EdgeInsets.all(6.0), // Añade espacio alrededor de la imagen
                        child: Image.asset(
                          'assets/images/config.png',
                          fit: BoxFit.cover, // La imagen cubrirá el área después del padding
                        ),
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
                      child: Padding(
                        padding: EdgeInsets.all(6.0), // Añade espacio alrededor de la imagen
                        child: Image.asset(
                          'assets/images/salvavidas.png',
                          fit: BoxFit.cover, // La imagen cubrirá el área después del padding
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 3,
              height: 0,
              indent: 23,
              endIndent: 23,
            ),
            SizedBox(height: 20),

            InkWell( // Se envuelve el Container con InkWell
              onTap: () {
                // Navega a HelpScreen cuando se presiona el ícono
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              // Botón principal "¿Quieres hablar conmigo?"

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Color(0xFF87CEEB),
                  borderRadius: BorderRadius.circular(45),
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
            ),

            SizedBox(height: 20),

            // Botón "ESCOGER UN TEMA"
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0BBDAC), // centro
                    Color(0xFF6110E8), // bordes
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(35),
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
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: 16,
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(

                        children: [
                          Text(
                            'Conversaciones',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                height: 1.2
                            ),
                          ),
                          SizedBox(height: 23),
                          Container(
                            width: 90,
                            height: 95,
                            decoration: BoxDecoration(
                              color: Color(0xFF87CEEB),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/conversaciones.png'),
                                fit: BoxFit.cover,
                              ),
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Progreso de las\nActividades',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container( // Circulo del icono
                            width: 100,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Color(0xFF87CEEB),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/medalla.png'),
                                fit: BoxFit.cover,
                              ),
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

          ],
        ),
      ),
    );
  }
}