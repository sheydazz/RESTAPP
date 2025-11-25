import 'package:flutter/material.dart';
import '../home/screens/home_screen.dart';
import '../progress/screens/progress_screen.dart';
import '../emotion/screens/emotionregister_screen.dart';
import '../progress/screens/myprogress_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProgressScreen(), // 📊 Progreso
    MyProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// 🌊 Barra personalizada tipo "onda suave"
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF4DB6AC), Color(0xFF3F51B5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItem(Icons.home, 0, context),
          _buildItem(Icons.pie_chart, 1, context),
          _buildItem(Icons.person, 2, context),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, int index, BuildContext context) {
    bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.9) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 30,
          color: isActive ? const Color(0xFF4A90E2) : Colors.white,
        ),
      ),
    );
  }
}
