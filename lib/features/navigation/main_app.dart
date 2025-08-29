import 'package:flutter/material.dart';
import '../home/screens/home_screen.dart';
import '../emotion/screens/emotionregister_screen.dart';
import '../progress/screens/progress_screen.dart';


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    // TrafficLightScreen(
    //   estado: "excelente", // excelente" "alerta-amarillo", "alerta-rojo"
    //   mensaje: "sigue asi ",
    //   botonTexto: "consejo",
    // ), // 🏠 Inicio
    EmotionRegisterScreen(), // 😊 Registro emocional
    ProgressScreen(), // 📊 Progreso
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Emociones'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progreso',
          ),
        ],
      ),
    );
  }
}
