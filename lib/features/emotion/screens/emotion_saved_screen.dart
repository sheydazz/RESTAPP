import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

/// Pantalla de confirmación cuando el registro emocional se guarda correctamente.
/// Aparece después de completar el test y antes del semáforo emocional.
class EmotionSavedScreen extends StatefulWidget {
  final Map<String, dynamic>
  resultado; // Datos del test para pasar a traffic light

  const EmotionSavedScreen({super.key, required this.resultado});

  @override
  State<EmotionSavedScreen> createState() => _EmotionSavedScreenState();
}

class _EmotionSavedScreenState extends State<EmotionSavedScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _slideController;
  late Animation<double> _checkAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animación del checkmark
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    // Animación de slide para el texto
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Navegar a WhatsApp después de 10 segundos
    Future.delayed(const Duration(seconds: 10), () async {
      if (mounted) {
        // Número de WhatsApp del psicólogo - CONFIGURA AQUÍ TU NÚMERO
        const String psychologistPhone =
            '+573015460169'; // Sin espacios para WhatsApp
        const String message =
            'Hola, he enviado una solicitud de ayuda desde REST.';

        // Crear URL de WhatsApp
        final String whatsappUrl =
            'https://wa.me/$psychologistPhone?text=${Uri.encodeComponent(message)}';

        try {
          if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
            await launchUrl(
              Uri.parse(whatsappUrl),
              mode: LaunchMode.externalApplication,
            );
            // Cerrar la pantalla después de abrir WhatsApp
            if (mounted) {
              Navigator.pop(context);
            }
          } else {
            // Si no se puede abrir WhatsApp, ir al traffic light como fallback
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.trafficLight,
              arguments: widget.resultado,
            );
          }
        } catch (e) {
          // En caso de error, ir al traffic light
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.trafficLight,
            arguments: widget.resultado,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: Center(
        child: Container(
          width: 400,
          height: 800,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Checkmark animado
              ScaleTransition(
                scale: _checkAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF08D557), Color(0xFF41AC20)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF08D557).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Texto principal con animación de slide
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _slideController,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF08D557), Color(0xFF41AC20)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: const Text(
                          '¡REGISTRO\nEMOCIONAL\nGUARDADO!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Tu estado de ánimo ha sido registrado con éxito',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Indicador de carga animado
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.outlineVariant),
                  strokeWidth: 3,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Preparando tu resultado...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
