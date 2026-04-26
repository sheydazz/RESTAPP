import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';
import 'package:rest/core/services/auth_service.dart';
import 'package:rest/core/routes/app_routes.dart';
import 'package:rest/core/services/user_session.dart';
import 'package:rest/features/emotion/screens/emotionregister_screen.dart';
import 'package:rest/features/navigation/main_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final correo = _emailController.text.trim();
    final contrasena = _passwordController.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa correo y contraseña')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login(
        correo: correo,
        contrasena: contrasena,
      );

      // Extraer un posible nombre desde la respuesta o usar el correo
      String nombre = correo.split('@').first;
      if (response['nombres'] is String) {
        nombre = response['nombres'];
      } else if (response['user'] is Map &&
          (response['user'] as Map)['nombres'] is String) {
        nombre = (response['user'] as Map)['nombres'] as String;
      }

      UserSession.currentUserName = nombre;

      print('LOGIN PARSED → response keys: ${response.keys.toList()}');

      // Guardar token e id de usuario si vienen en la respuesta
      final dynamic token =
          response['token'] ??
          response['accessToken'] ??
          response['jwt'] ??
          (response['data'] is Map ? (response['data'] as Map)['token'] : null);

      print('LOGIN PARSED → token type: ${token.runtimeType}, value: $token');

      if (token is String && token.isNotEmpty) {
        UserSession.authToken = token;
      }

      // El login puede devolver user/usuario en distintos formatos (el del login viene mal)
      final dynamic user =
          response['user'] ??
          response['usuario'] ??
          (response['data'] is Map
              ? (response['data'] as Map)['user']
              : null) ??
          (response['data'] is Map
              ? (response['data'] as Map)['usuario']
              : null);

      print('LOGIN PARSED → user type: ${user.runtimeType}, value: $user');

      if (user is Map) {
        final id = user['id'];
        if (id is int) {
          UserSession.userId = id;
        } else if (id is num) {
          UserSession.userId = id.toInt();
        } else if (id is String) {
          UserSession.userId = int.tryParse(id);
        }
      }
      if (UserSession.userId == null && response['id'] != null) {
        final id = response['id'];
        if (id is int) {
          UserSession.userId = id;
        } else if (id is num) {
          UserSession.userId = id.toInt();
        } else if (id is String) {
          UserSession.userId = int.tryParse(id);
        }
      }

      // IMPORTANTE: Resetear lastTestDate para cada nuevo usuario
      // Esto garantiza que TODOS los usuarios nuevos vean el test
      UserSession.lastTestDate = null;

      print(
        'LOGIN SESSION → authToken=${UserSession.authToken != null ? 'SET' : 'NULL'}, userId=${UserSession.userId}',
      );

      if (!mounted) return;

      // Validar si el usuario puede hacer el test hoy (solo una vez al día)
      if (UserSession.canDoTestToday()) {
        // Mostrar EmotionRegisterScreen si puede hacer el test
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmotionRegisterScreen(),
          ),
        );
      } else {
        // Si ya hizo el test hoy, ir a MainApp
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainApp()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          // ← Solución al overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/restSalud.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                _buildInputField(
                  controller: _emailController,
                  label: 'USUARIO O CORREO INSTITUCIONAL',
                  hint: 'Example@correo.com',
                ),

                const SizedBox(height: 32),

                _buildInputField(
                  controller: _passwordController,
                  label: 'CONTRASEÑA',
                  hint: '••••••••',
                  obscure: true,
                ),
                const SizedBox(height: 50),

                _buildRadialButton(
                  text: _isLoading ? 'CARGANDO...' : 'INGRESAR',
                  onPressed: _isLoading ? null : () => _handleLogin(),
                ),

                const SizedBox(height: 10),

                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.fredoka(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '¿Se te olvidó? ',
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            TextSpan(
                              text: 'Recuperar',
                              style: TextStyle(color: Color(0xFF2B13B2)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: colorScheme.outlineVariant, thickness: 1, height: 30),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  '¿Eres nueva/o?',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenidos a ',
                      style: GoogleFonts.fredoka(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFAB07D8), Color(0xFF1579EC)],
                      ).createShader(bounds),
                      child: Text(
                        'REST',
                        style: GoogleFonts.fredoka(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: _buildRadialJoinButton(
                    text: 'UNIRME',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 16,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFADD8E6), Color(0xFF3A5AFF), Color(0xFF8C4EFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.fredoka(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.fredoka(
                  color: colorScheme.onSurfaceVariant,
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
                      child: Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
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
      colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
    );

    return Container(
      width: double.infinity,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
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

  Widget _buildRadialJoinButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    final gradient = const RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
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
