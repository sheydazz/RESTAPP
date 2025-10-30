import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildRegistroEmocional(),
                const SizedBox(height: 24),
                _buildActividadesDiarias(),
                const SizedBox(height: 24),
                _buildMiDiario(context),
                const SizedBox(height: 24),
                _buildTecnicasRelajacion(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // header
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF87CEEB),
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/normalrest.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '¡Hola! Mari',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7DD3E8),
                fontFamily: 'Fredoka',
              ),
            ),
            const Spacer(),
            // confi
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF7DD3E8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/white_gear.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.settings, color: Colors.white, size: 24);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // salvavidads
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF7DD3E8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/float.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.help_outline, color: Colors.white, size: 24);
                  },
                ),
              ),
            ),
          ],
        ),

        // divisor
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey[400],
          thickness: 3,
          height: 0,
          indent: 23,
          endIndent: 23,
        ),
      ],
    );
  }


  Widget _buildCircleIcon(String asset, IconData fallback) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF7DD3E8),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          asset,
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            return Icon(fallback, color: Colors.white, size: 24);
          },
        ),
      ),
    );
  }

  // semana emocional
  Widget _buildRegistroEmocional() {
    final diasSemana = [
      'LUNES',
      'MARTES',
      'MIÉRCOLES',
      'JUEVES',
      'VIERNES',
      'SÁBADO',
      'DOMINGO'
    ];
    final iconos = [
      'assets/images/green_face.png',
      'assets/images/pink_face.png',
      'assets/images/yellowrest.png',
      'assets/images/green_face.png',
      'assets/images/pink_face.png',
      'assets/images/yellowrest.png',
      'assets/images/green_face.png',
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Registro Emocional',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Column(
                  children: [
                    Text(
                      diasSemana[index],
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'Fredoka',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Image.asset(
                      iconos[index],
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // actividades diarias
  Widget _buildActividadesDiarias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis actividades diarias',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7DD3E8), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActividadItem('1. Juega un rato', true),
              _buildActividadItem('2. Desahógate en el gimnasio', false),
              _buildActividadItem('3. Habla con una persona', false),
              _buildActividadItem('4. Sal a correr con música', true),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Ver todas',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Fredoka',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActividadItem(String texto, bool completada) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Fredoka',
              ),
            ),
          ),
          Icon(
            Icons.star,
            color: completada ? const Color(0xFFFFA726) : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  // diario
  Widget _buildMiDiario(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mi diario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.miDiario);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7DD3E8), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/dairy.jpg',
                  width: 110,
                  height: 90,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Escribe aquí todas las cosas importantes de tu día',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- TÉCNICAS DE RELAJACIÓN ----------------
  Widget _buildTecnicasRelajacion(BuildContext context) {
    final tecnicas = [
      {'nombre': 'Yoga', 'icono': 'assets/images/yoga.png'},
      {'nombre': 'Chistes', 'icono': 'assets/images/chistes.png'},
      {'nombre': 'Juegos', 'icono': 'assets/images/juegos.png'},
      {'nombre': 'Escuchar Música', 'icono': 'assets/images/musica.png'},
      {'nombre': 'Actividad Física', 'icono': 'assets/images/gym.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis técnicas de relajación',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),

        // Cuadro centrado con GridView
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7DD3E8), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
            children: List.generate(tecnicas.length, (index) {
              final tecnica = tecnicas[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.misTecnicas);
                },
                child: _buildTecnicaCard(tecnica['nombre']!, tecnica['icono']!),
              );
            }),
          ),
        ),
      ],
    );
  }

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
