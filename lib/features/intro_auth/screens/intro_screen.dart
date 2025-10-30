import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _noaMoveController;
  late AnimationController _noaPulseController;
  late AnimationController _shadowController;
  late AnimationController _shadowFadeController;

  late Animation<double> _logoPosition;
  late Animation<double> _noaVerticalPosition;
  late Animation<double> _noaScale;
  late Animation<double> _noaPulse;
  late Animation<double> _shadowWidth;
  late Animation<double> _shadowHeight;
  late Animation<double> _shadowFadeOut;

  double shadowOpacity = 0.0;
  bool showNoa = false;
  bool showHola = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _noaMoveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _noaPulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shadowFadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _noaVerticalPosition = Tween<double>(begin: 260, end: 0).animate(
      CurvedAnimation(parent: _noaMoveController, curve: Curves.easeOut),
    );

    _noaScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _noaMoveController, curve: Curves.easeOut),
    );

    _noaPulse = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _noaPulseController, curve: Curves.easeInOut),
    );

    _shadowWidth = Tween<double>(begin: 311.0, end: 60.0).animate(
      CurvedAnimation(parent: _shadowController, curve: Curves.easeOut),
    );

    _shadowHeight = Tween<double>(begin: 70.0, end: 20.0).animate(
      CurvedAnimation(parent: _shadowController, curve: Curves.easeOut),
    );

    _shadowFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _shadowFadeController, curve: Curves.easeOut),
    );

    // Secuencia de animaciones
    Timer(const Duration(seconds: 5), () {
      _logoController.forward();
    });

    Timer(const Duration(milliseconds: 5500), () {
      setState(() {
        shadowOpacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 6), () {
      setState(() {
        showNoa = true;
      });
      _noaMoveController.forward();
      _shadowController.forward();
    });

    Timer(const Duration(milliseconds: 6800), () {
      _shadowFadeController.forward(); // desaparece después de encogerse
    });

    Timer(const Duration(seconds: 7), () {
      setState(() {
        showHola = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double screenHeight = MediaQuery.of(context).size.height;

    _logoPosition = Tween<double>(
      begin: 0.0,
      end: -screenHeight / 3,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _noaMoveController.dispose();
    _noaPulseController.dispose();
    _shadowController.dispose();
    _shadowFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _noaMoveController,
          _noaPulseController,
          _shadowController,
          _shadowFadeController,
        ]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Imagen "REST Salud Mental"
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, _logoPosition.value),
                  child: Image.asset(
                    'assets/images/restSalud.png',
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Sombra azul: aparece, se encoge, luego desaparece
              Positioned(
                bottom: 270,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: shadowOpacity * _shadowFadeOut.value,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_shadowController, _shadowFadeController]),
                    builder: (context, child) {
                      return Container(
                        width: _shadowWidth.value,
                        height: _shadowHeight.value,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8D7FF),
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(_shadowWidth.value, _shadowHeight.value),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Noa: sube desde la sombra y palpita
              if (showNoa)
                Transform.translate(
                  offset: Offset(0, _noaVerticalPosition.value),
                  child: Transform.scale(
                    scale: _noaScale.value * _noaPulse.value,
                    child: Image.asset(
                      'assets/images/rest.png',
                      width: 270,
                      height: 270,
                    ),
                  ),
                ),

              // Imagen "Hola" y botón Iniciar
              if (showHola)
                Positioned(
                  bottom: 100,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: 1.0,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/hola.png',
                          width: 248,
                          height: 115,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF22AF95), // aguamarina izquierda
                                Color(0xFF207DC3), // morado derecha
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Iniciar',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
