import 'dart:async';
import 'package:rest/core/utils/app_toast.dart';
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

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _buttonPressed = false;
  bool _joinButtonPressed = false;

  // Animaciones de entrada
  late AnimationController _entryCtrl;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _field1Fade;
  late Animation<Offset> _field1Slide;
  late Animation<double> _field2Fade;
  late Animation<Offset> _field2Slide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _bottomFade;
  late Animation<Offset> _bottomSlide;

  // Shimmer del botón
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmer;

  // Flecha del botón UNIRME
  late AnimationController _arrowCtrl;
  late Animation<double> _arrowOffset;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));

    // Controlador de entrada en cascada
    _entryCtrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );

    _field1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.2, 0.55, curve: Curves.easeOut)),
    );
    _field1Slide = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.2, 0.55, curve: Curves.easeOut)),
    );

    _field2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.35, 0.65, curve: Curves.easeOut)),
    );
    _field2Slide = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.35, 0.65, curve: Curves.easeOut)),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.5, 0.78, curve: Curves.easeOut)),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.5, 0.78, curve: Curves.easeOut)),
    );

    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
    );
    _bottomSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
    );

    // Shimmer continuo en botón INGRESAR
    _shimmerCtrl = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();
    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );

    // Flecha animada en UNIRME
    _arrowCtrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
    _arrowOffset = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _arrowCtrl, curve: Curves.easeInOut),
    );

    // Lanzar animación de entrada
    Timer(const Duration(milliseconds: 100), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _entryCtrl.dispose();
    _shimmerCtrl.dispose();
    _arrowCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final correo = _emailController.text.trim();
    final contrasena = _passwordController.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      AppToast.warning(context, 'Ingresa correo y contraseña');
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

      await UserSession.persist();

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
      AppToast.error(context, e.toString());
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

    return AnimatedBuilder(
      animation: Listenable.merge([_entryCtrl, _shimmerCtrl, _arrowCtrl]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── LOGO ──
                    FadeTransition(
                      opacity: _logoFade,
                      child: SlideTransition(
                        position: _logoSlide,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 0),
                          child: Image.asset(
                            'assets/images/restSalud-removebg-preview.png',
                            width: 200,
                            height: 160,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // ── CAMPO EMAIL ──
                    FadeTransition(
                      opacity: _field1Fade,
                      child: SlideTransition(
                        position: _field1Slide,
                        child: _buildAnimatedField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          label: 'Usuario o correo',
                          hint: 'example@correo.com',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── CAMPO CONTRASEÑA ──
                    FadeTransition(
                      opacity: _field2Fade,
                      child: SlideTransition(
                        position: _field2Slide,
                        child: _buildAnimatedField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          label: 'Contraseña',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── OLVIDÉ CONTRASEÑA ──
                    FadeTransition(
                      opacity: _field2Fade,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: '¿Se te olvidó? ',
                                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                                ),
                                const TextSpan(
                                  text: 'Recuperar →',
                                  style: TextStyle(color: Color(0xFF2B13B2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── BOTÓN INGRESAR ──
                    FadeTransition(
                      opacity: _buttonFade,
                      child: SlideTransition(
                        position: _buttonSlide,
                        child: _buildIngresarButton(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── DIVIDER ──
                    FadeTransition(
                      opacity: _bottomFade,
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '¿Eres nueva/o?',
                              style: GoogleFonts.fredoka(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 1)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── BIENVENIDA ──
                    FadeTransition(
                      opacity: _bottomFade,
                      child: SlideTransition(
                        position: _bottomSlide,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bienvenidos a ',
                              style: GoogleFonts.fredoka(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFAB07D8), Color(0xFF1579EC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'REST',
                                style: GoogleFonts.fredoka(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── BOTÓN UNIRME ──
                    FadeTransition(
                      opacity: _bottomFade,
                      child: SlideTransition(
                        position: _bottomSlide,
                        child: _buildUnirmeButton(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── CARTEL NOA ──
                    FadeTransition(
                      opacity: _bottomFade,
                      child: SlideTransition(
                        position: _bottomSlide,
                        child: _buildNoaCard(colorScheme),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoaCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3A5AFF).withOpacity(0.08),
            const Color(0xFF8C4EFF).withOpacity(0.08),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(
          color: const Color(0xFF3A5AFF).withOpacity(0.18),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/NoaBase.png',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola! Soy NOA 👋',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B13B2),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Ingresa o únete y te acompañaré en tu bienestar mental cada día.',
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Campo con focus animado, floating label y toggle contraseña ──
  Widget _buildAnimatedField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFocused = focusNode.hasFocus;
    final hasText = controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF3A5AFF).withOpacity(0.22),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.fredoka(
              fontSize: isFocused || hasText ? 13 : 15,
              fontWeight: FontWeight.bold,
              color: isFocused ? const Color(0xFF3A5AFF) : colorScheme.onSurfaceVariant,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(label),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: isFocused
                  ? const LinearGradient(
                      colors: [Color(0xFF3A5AFF), Color(0xFF8C4EFF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFCDD8FF), Color(0xFFD8C8FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                obscureText: isPassword && !_passwordVisible,
                style: GoogleFonts.fredoka(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.fredoka(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontSize: 15,
                  ),
                  prefixIcon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      icon,
                      color: isFocused ? const Color(0xFF3A5AFF) : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasText)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: AnimatedScale(
                            scale: hasText ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.elasticOut,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3709EC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 15),
                            ),
                          ),
                        ),
                      if (isPassword)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                _passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                key: ValueKey(_passwordVisible),
                                color: isFocused ? const Color(0xFF3A5AFF) : colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Botón INGRESAR con shimmer + scale al presionar ──
  Widget _buildIngresarButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _buttonPressed = true),
      onTapUp: (_) {
        setState(() => _buttonPressed = false);
        if (!_isLoading) _handleLogin();
      },
      onTapCancel: () => setState(() => _buttonPressed = false),
      child: AnimatedScale(
        scale: _buttonPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2981C1).withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Shimmer
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(_shimmer.value * 300, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.18),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'INGRESAR',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            letterSpacing: 1.5,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Botón UNIRME con flecha animada ──
  Widget _buildUnirmeButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _joinButtonPressed = true),
      onTapUp: (_) {
        setState(() => _joinButtonPressed = false);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, __) => const RegisterScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      onTapCancel: () => setState(() => _joinButtonPressed = false),
      child: AnimatedScale(
        scale: _joinButtonPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2.5,
                color: Colors.transparent,
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5CCFC0).withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UNIRME',
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 8),
                Transform.translate(
                  offset: Offset(_arrowOffset.value, 0),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
