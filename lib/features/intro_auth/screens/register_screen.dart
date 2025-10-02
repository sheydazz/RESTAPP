import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'how_you_found_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool wantsToChangePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Imagen + Título en una fila
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/normalrest.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0419FF),
                          Color(0xFF0AF3FF),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        '¡Háblame de ti!',
                        style: GoogleFonts.fredoka(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              _buildInputField(label: '¿Cómo quieres que te llame?', hint: 'Tu nombre'),
              const SizedBox(height: 20),
              _buildInputField(label: '¿Cuántos años tienes?', hint: 'Edad'),
              const SizedBox(height: 20),
              _buildInputField(label: '¿De qué ciudad eres?', hint: 'Ciudad'),
              const SizedBox(height: 20),
              _buildInputField(label: '¿Cuál es tu carrera?', hint: 'Ej. Psicología'),
              const SizedBox(height: 20),
              _buildInputField(label: '¿Qué semestres cursas?', hint: 'Ej. 3 y 4'),

              const SizedBox(height: 30),

              Row(
                children: [
                  Checkbox(
                    value: wantsToChangePassword,
                    activeColor: const Color(0xFF3709EC),
                    onChanged: (value) {
                      setState(() {
                        wantsToChangePassword = value!;
                      });
                    },
                  ),
                  Text(
                    '¿Quieres cambiar tu contraseña?',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: wantsToChangePassword
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (wantsToChangePassword)
                _buildInputField(
                  label: 'Nueva contraseña',
                  hint: '••••••••',
                  obscure: true,
                ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: _buildRadialButton(
                    text: 'GUARDAR',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HowYouFoundScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFADD8E6),
                Color(0xFF3A5AFF),
                Color(0xFF8C4EFF),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              obscureText: obscure,
              style: GoogleFonts.fredoka(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.fredoka(
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3709EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadialButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    final gradient = const RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        Color(0xFF5CCFC0),
        Color(0xFF2981C1),
      ],
    );

    return Container(
      height: 65,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: Text(
          text,
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
    );
  }
}