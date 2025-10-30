import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MisCapitulosScreen extends StatelessWidget {
  const MisCapitulosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = const RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
    );

    final capitulos = [
      {
        'titulo': 'Me duele',
        'descripcion': 'Puede que esté pasando en mis días normales...',
        'fecha': '10/03/2025',
      },
      {
        'titulo': 'Me siento raro',
        'descripcion': 'A veces me cuesta concentrarme...',
        'fecha': '15/03/2025',
      },
      {
        'titulo': 'Tristeza',
        'descripcion': 'Hoy fue un día difícil...',
        'fecha': '20/03/2025',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),


                      ShaderMask(
                        shaderCallback: (bounds) =>
                            gradient.createShader(bounds),
                        child: Text(
                          'Mis Capítulos',
                          style: GoogleFonts.fredoka(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
              ),
            ),

            // 🔹 LISTA DE CAPÍTULOS
            Expanded(
              child: capitulos.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay capítulos aún',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontFamily: 'Fredoka',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza escribiendo en tu diario',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontFamily: 'Fredoka',
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: capitulos.length,
                itemBuilder: (context, index) {
                  final capitulo = capitulos[index];
                  return _buildCapituloCard(
                    context,
                    capitulo['titulo']!,
                    capitulo['descripcion']!,
                    capitulo['fecha']!,
                    gradient,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapituloCard(
      BuildContext context,
      String titulo,
      String descripcion,
      String fecha,
      RadialGradient gradient,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/capitulo-detalle',
          arguments: {
            'titulo': titulo,
            'descripcion': descripcion,
            'fecha': fecha,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(2), // gradiente
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                titulo,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // descrip
              Text(
                descripcion,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // date
              Text(
                fecha,
                style: GoogleFonts.fredoka(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
