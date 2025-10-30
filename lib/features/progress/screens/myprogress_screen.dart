import 'package:flutter/material.dart';
import 'package:rest/features/progress/screens/globalprogress_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../help/screens/help_screen.dart';
import 'progress_screen.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({super.key});

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

            // 🔹 Texto principal
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "He trabajado 3 días en mí",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔹 Streak con días
            InkWell(
              onTap: () {
                // Navega a ProgressScreen (GlobalProgress) cuando se presiona el contenedor de la racha
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GlobalProgressScreen()),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _DayItem(day: "Lunes", active: true),
                        _DayItem(day: "Martes"),
                        _DayItem(day: "Miércoles"),
                        _DayItem(day: "Jueves"),
                        _DayItem(day: "Viernes", active: true),
                        _DayItem(day: "Sábado"),
                        _DayItem(day: "Domingo", active: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "¡Mantén la racha para ganar premios!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Cards de análisis
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _InfoCard(
                      title: "Estado de ánimo más frecuente",
                      content:
                          "No se ha registrado ningún estado de ánimo hasta el momento",
                    ),
                    _InfoCard(
                      title: "Emociones más frecuentes",
                      content:
                          "No se han registrado emociones de tus sesiones más frecuentes",
                    ),
                    _InfoCard(
                      title: "Evolución del estado de ánimo",
                      content:
                          "No se han registrado estados de ánimo en el periodo seleccionado",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Componente Día
class _DayItem extends StatelessWidget {
  final String day;
  final bool active;

  const _DayItem({required this.day, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        active
            ? const Text("🔥", style: TextStyle(fontSize: 24))
            : const Text("○", style: TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

// 🔹 Componente Card Info
class _InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const _InfoCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
