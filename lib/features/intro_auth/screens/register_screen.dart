import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'how_you_found_screen.dart';
import 'package:rest/core/services/auth_service.dart';
import 'package:rest/core/services/user_session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _edadController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _carreraController = TextEditingController();
  final _semestresController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _edadController.dispose();
    _ciudadController.dispose();
    _carreraController.dispose();
    _semestresController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final nombres = _nombreController.text.trim();
    final apellidos = _apellidoController.text.trim();
    final correo = _correoController.text.trim();
    final contrasena = _passwordController.text.trim();
    final ciudad = _ciudadController.text.trim();
    final telefono = _telefonoController.text.trim();
    final edadText = _edadController.text.trim();
    final edad = int.tryParse(edadText);

    if (nombres.isEmpty ||
        apellidos.isEmpty ||
        correo.isEmpty ||
        contrasena.isEmpty ||
        ciudad.isEmpty ||
        telefono.isEmpty ||
        edad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa nombre, apellido, correo, contraseña, ciudad, teléfono y una edad válida',
          ),
        ),
      );
      return;
    }

    // Validar formato de correo
    final emailRegExp =
        RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false);
    if (!emailRegExp.hasMatch(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un correo válido'),
        ),
      );
      return;
    }

    // Validar longitud de contraseña (> 8 caracteres)
    if (contrasena.length <= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener más de 8 caracteres'),
        ),
      );
      return;
    }

    // Validar teléfono: solo dígitos y más de 6
    final phoneRegExp = RegExp(r'^\d+$');
    if (!phoneRegExp.hasMatch(telefono) || telefono.length <= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('El teléfono debe tener solo números y más de 6 dígitos'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.register(
        correo: correo,
        contrasena: contrasena,
        nombres: nombres,
        apellidos: apellidos,
        telefono: telefono,
        ciudad: ciudad,
        edad: edad,
      );

      UserSession.currentUserName = nombres;

      // Guardar token y userId directamente del registro (el del login viene mal)
      final dynamic token =
          response['token'] ??
          response['accessToken'] ??
          response['jwt'] ??
          (response['data'] is Map ? (response['data'] as Map)['token'] : null);
      if (token is String && token.isNotEmpty) {
        UserSession.authToken = token;
      }

      final dynamic user =
          response['user'] ??
          (response['data'] is Map ? (response['data'] as Map)['user'] : null);
      if (user is Map && user['id'] is int) {
        UserSession.userId = user['id'] as int;
      } else if (response['id'] is int) {
        UserSession.userId = response['id'] as int;
      }

      print('REGISTER SESSION → token=${UserSession.authToken != null ? 'SET' : 'NULL'}, userId=${UserSession.userId}');

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HowYouFoundScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

              _buildInputField(
                controller: _nombreController,
                label: '¿Cómo quieres que te llame?',
                hint: 'Tu nombre',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _edadController,
                label: '¿Cuántos años tienes?',
                hint: 'Edad',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _ciudadController,
                label: '¿De qué ciudad eres?',
                hint: 'Ciudad',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _carreraController,
                label: '¿Cuál es tu carrera?',
                hint: 'Ej. Psicología',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _semestresController,
                label: '¿Qué semestres cursas?',
                hint: 'Ej. 3 y 4',
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: _telefonoController,
                label: 'Teléfono',
                hint: '3001234567',
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: _apellidoController,
                label: 'Apellidos',
                hint: 'Tus apellidos',
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: _correoController,
                label: 'Correo institucional',
                hint: 'example@correo.com',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _passwordController,
                label: 'Contraseña',
                hint: '••••••••',
                obscure: true,
              ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: _buildRadialButton(
                    text: _isLoading ? 'GUARDANDO...' : 'GUARDAR',
                    onPressed: _isLoading ? null : () => _handleRegister(),
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
    required TextEditingController controller,
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
              controller: controller,
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
    required VoidCallback? onPressed,
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