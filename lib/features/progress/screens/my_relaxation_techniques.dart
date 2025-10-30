import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class MisTecnicasScreen extends StatelessWidget {
  const MisTecnicasScreen({super.key});

  // Gradiente principal
  LinearGradient get _gradient => const LinearGradient(
    colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    final tecnicas = [
      {'nombre': 'Yoga', 'icono': 'assets/images/yoga.png'},
      {'nombre': 'Chistes', 'icono': 'assets/images/chistes.png'},
      {'nombre': 'Juegos', 'icono': 'assets/images/juegos.png'},
      {'nombre': 'Escuchar Música', 'icono': 'assets/images/musica.png'},
      {'nombre': 'Actividad Física', 'icono': 'assets/images/gym.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón "X" con gradiente
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _gradient,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Título con texto degradado
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => _gradient.createShader(bounds),
                  child: const Text(
                    'Mis Técnicas de\nRelajación',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

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

              // Cuadro principal con borde degradado
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: _gradient,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tarjeta individual sin borde y con color azul #CCF0FF
  Widget _buildTecnicaCard(String nombre, String iconPath) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFCCF0FF),
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
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
