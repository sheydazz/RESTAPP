import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowYouFoundScreen extends StatefulWidget {
  const HowYouFoundScreen({super.key});

  @override
  State<HowYouFoundScreen> createState() => _HowYouFoundScreenState();
}

class _HowYouFoundScreenState extends State<HowYouFoundScreen> {
  String? selectedOption;

  final List<String> options = [
    'Por redes sociales',
    'Por publicidad',
    'Por Universidad',
    'Por otras cosas...',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView( // ← Solución al overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Título + Imagen + Estrellas + Subtítulo agrupados
                Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFCA0AFF),
                          Color(0xFF1298FF),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        '¡Perfecto!',
                        style: GoogleFonts.fredoka(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Muñequito con estrellas
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset('assets/images/rest.png'),
                          ),
                          Positioned(
                            top: 10,
                            left: 0,
                            child: Image.asset('assets/images/star.png', width: 30),
                          ),
                          Positioned(
                            top: 0,
                            right: 50,
                            child: Image.asset('assets/images/star.png', width: 20),
                          ),
                          Positioned(
                            top: 0,
                            left: 50,
                            child: Image.asset('assets/images/star.png', width: 25),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset('assets/images/star.png', width: 35),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            child: Image.asset('assets/images/star.png', width: 18),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset('assets/images/star.png', width: 22),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Image.asset('assets/images/star.png', width: 28),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '¡Una última cosa!',
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5020FD),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  '¿Cómo supiste de mí?',
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Opciones como botones
                ...options.map((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = option;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        color: selectedOption == option
                            ? const Color(0xFF5CCFC0)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFF5CCFC0),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == option
                              ? Colors.white
                              : const Color(0xFF2981C1),
                        ),
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 30),

                // Botón "Siguiente" con degradado radial y texto grande
                Container(
                  width: 345,
                  height: 52,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.centerLeft,
                      radius: 2.5,
                      colors: [
                        Color(0xFF0BBDAC),
                        Color(0xFF3667CA),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ElevatedButton(
                    onPressed: selectedOption != null
                        ? () {
                      // Acción al continuar
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      fixedSize: const Size(345, 52),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Siguiente',
                        style: GoogleFonts.fredoka(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
