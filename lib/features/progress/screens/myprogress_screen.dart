import 'package:flutter/material.dart';
import 'package:rest/features/progress/screens/globalprogress_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../help/screens/help_screen.dart';

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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar Mari
                  Container(
                    width: 100,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF87CEEB),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/normalrest.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texto "¡Hola! Mari"
                  const Text(
                    '¡Hola! Mari',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E86AB),
                    ),
                  ),
                  const Spacer(),
                  // Icono configuración (clickeable)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(), // 👈 SIN const
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF87CEEB),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/images/config.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Icono ayuda (clickeable)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpScreen(), // 👈 SIN const
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF87CEEB),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/images/salvavidas.png',
                          fit: BoxFit.cover,
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
            const SizedBox(height: 20),

            // 🔹 Texto principal
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "He trabajado 3 días en mí",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Botón de racha (CLARAMENTE clickeable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                color: const Color(0xFFE3F4FF),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GlobalProgressScreen(), // 👈 SIN const
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fila título + icono fuego + flecha
                        Row(
                          children: const [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Mi racha de bienestar",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Días
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
                        const Center(
                          child: Text(
                            "Toca aquí para ver tu progreso detallado",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Cards de análisis (NO clickeables, estilo más neutro)
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _InfoCard(
                      title: "Estado de ánimo más frecuente",
                      content:
                      "No se ha registrado ningún estado de ánimo hasta el momento.",
                    ),
                    _InfoCard(
                      title: "Emociones más frecuentes",
                      content:
                      "No se han registrado emociones de tus sesiones más frecuentes.",
                    ),
                    _InfoCard(
                      title: "Evolución del estado de ánimo",
                      content:
                      "No se han registrado estados de ánimo en el periodo seleccionado.",
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
        Text(
          active ? "🔥" : "○",
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

// 🔹 Componente Card Info (no clickeable, visualmente más "lectura")
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
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
