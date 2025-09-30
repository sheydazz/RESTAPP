import 'package:flutter/material.dart';

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
                // Header
                _buildHeader(context),
                const SizedBox(height: 20),

                // Registro Emocional
                _buildRegistroEmocional(),
                const SizedBox(height: 24),

                // Mis actividades diarias
                _buildActividadesDiarias(),
                const SizedBox(height: 24),

                // Mi diario
                _buildMiDiario(context),
                const SizedBox(height: 24),

                // Mis técnicas de relajación
                _buildTecnicasRelajacion(),
                const SizedBox(height: 80), // Espacio para la barra de navegación
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF7DD3E8),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/normalrest.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, color: Colors.white, size: 30);
              },
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
        // Configuración
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF7DD3E8),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/white_gear.jpg',
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.settings, color: Colors.white, size: 24);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Salvavidas
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/float.jpg',
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.help_outline, color: Colors.white, size: 24);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistroEmocional() {
    final diasSemana = ['LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO', 'DOMINGO'];
    final iconos = [
      'assets/images/goodrest.jpg',
      'assets/images/goodrest.jpg',
      'assets/images/goodrest.jpg',
      'assets/images/goodrest.jpg',
      'assets/images/yellowrest.jpg',
      'assets/images/yellowrest.jpg',
      'assets/images/sadrest.jpg',
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Registro Emocional',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 16),
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
                    Container(
                      width: 32,
                      height: 32,
                      child: Image.asset(
                        iconos[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.face, size: 20),
                          );
                        },
                      ),
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

  Widget _buildActividadesDiarias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis actividades diarias',
          style: TextStyle(
            fontSize: 20,
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
              fontWeight: FontWeight.w600,
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
                color: Colors.black87,
                fontFamily: 'Fredoka',
              ),
            ),
          ),
          if (completada)
            const Icon(
              Icons.star,
              color: Color(0xFFFFA726),
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildMiDiario(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mi diario',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/mi-diario');
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
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.brown,
                      child: const Icon(Icons.book, color: Colors.white),
                    );
                  },
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Escribe aquí todas las cosas importantes de tu día',
                    style: TextStyle(
                      fontSize: 14,
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

  Widget _buildTecnicasRelajacion() {
    final tecnicas = [
      {'nombre': 'Yoga', 'icono': 'assets/images/yoga.jpg'},
      {'nombre': 'Chistes', 'icono': 'assets/images/chistes.jpg'},
      {'nombre': 'Juegos', 'icono': 'assets/images/juegos.jpg'},
      {'nombre': 'Escuchar\nMusica', 'icono': 'assets/images/musica.jpg'},
      {'nombre': 'Actividad\nFísica', 'icono': 'assets/images/gym.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis técnicas de relajación',
          style: TextStyle(
            fontSize: 20,
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
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(tecnicas.length, (index) {
              return _buildTecnicaCard(
                tecnicas[index]['nombre']!,
                tecnicas[index]['icono']!,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTecnicaCard(String nombre, String iconPath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.white),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontFamily: 'Fredoka',
            ),
          ),
        ],
      ),
    );
  }
}