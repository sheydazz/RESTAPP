// intro_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _characterController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _characterAnimation;

  int currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Controladores de animación
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Animaciones
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _characterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.bounceOut),
    );

    // Secuencia de animación
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // Paso 1: Solo logo REST
    setState(() => currentStep = 0);
    _fadeController.forward();

    Timer(const Duration(milliseconds: 1500), () {
      // Paso 2: Logo + sombra
      setState(() => currentStep = 1);
      _scaleController.forward();

      Timer(const Duration(milliseconds: 1000), () {
        // Paso 3: Aparece personaje
        setState(() => currentStep = 2);
        _characterController.forward();

        Timer(const Duration(milliseconds: 1200), () {
          // Paso 4: Personaje feliz + texto
          setState(() => currentStep = 3);

          Timer(const Duration(milliseconds: 1500), () {
            // Navegar al login
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _characterController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo REST
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: currentStep >= 1 ? _scaleAnimation.value : 1.0,
                        child: Column(
                          children: [
                            // Logo REST con gradiente azul exacto
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF29B6F6), // Azul claro
                                    Color(0xFF1976D2), // Azul más oscuro
                                  ],
                                ).createShader(bounds);
                              },
                              child: const Text(
                                "REST",
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w900, // MUY grueso
                                  color: Colors.white,
                                  letterSpacing: -1, // Más juntas
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Salud Mental",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF424242), // Más oscuro
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 80),

            // Sombra elíptica (aparece en paso 1)
            if (currentStep >= 1)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: currentStep >= 1 ? 1.0 : 0.0,
                child: Container(
                  width: 140,
                  height: 25,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00BCD4).withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.3, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
              ),

            // Personaje NOA (aparece en paso 2)
            if (currentStep >= 2)
              AnimatedBuilder(
                animation: _characterController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _characterAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFF4DFFDF), // Verde agua claro
                            Color(0xFF00BCD4), // Cyan
                          ],
                          stops: [0.3, 1.0],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BCD4).withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            // Ojos - círculos blancos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Boca - sonrisa blanca en paso 3, línea en otros
                            if (currentStep >= 3)
                              Container(
                                width: 20,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 12,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Texto de saludo (aparece en paso 3)
            if (currentStep >= 3)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: 1.0,
                child: Column(
                  children: [
                    const Text(
                      "¡HOLA!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900, // MUY grueso
                        color: Color(0xFF29B6F6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      "SOY NOA",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900, // MUY grueso
                        color: Color(0xFF29B6F6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF29B6F6), // Azul claro
                            Color(0xFF1976D2), // Azul más oscuro
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF29B6F6).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        "INICIAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800, // Más grueso
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}