import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class MisTecnicasScreen extends StatelessWidget {
  const MisTecnicasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tecnicas = [
      {'nombre': 'Yoga', 'icono': 'assets/images/yoga.png'},
      {'nombre': 'Chistes', 'icono': 'assets/images/chistes.png'},
      {'nombre': 'Juegos', 'icono': 'assets/images/juegos.png'},
      {'nombre': 'Escuchar Musica', 'icono': 'assets/images/musica.png'},
      {'nombre': 'Actividad Fisica', 'icono': 'assets/images/gym.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Botón "X" para cerrar
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7DD3E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 Título centrado
              const Center(
                child: Text(
                  'Mis Técnicas de\nRelajación',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D9CDB),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Subtítulo con estrella
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  '⭐ Lo importante es mantener la calma y hacer algo que disfrutes',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Cuadro principal con borde y esquinas redondeadas
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF2D9CDB), width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: List.generate(tecnicas.length, (index) {
                      final tecnica = tecnicas[index];
                      return _buildTecnicaCard(tecnica['nombre']!, tecnica['icono']!);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTecnicaCard(String nombre, String iconPath) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Text(
                nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
