import 'package:flutter/material.dart';
import '../../settings/screens/settings_screen.dart';
import 'activities_screen.dart';
import 'package:rest/features/emotion/screens/chat_screen.dart';
import 'conversations_screen.dart';
import 'package:rest/core/services/user_session.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar Mari
                  Container(
                    width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF87CEEB),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/normalrest.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Texto "¡Hola! <nombre>"
                  Text(
                    '¡Hola! ${UserSession.displayName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  Spacer(),
                  // Iconos derecha
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF87CEEB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: colorScheme.outlineVariant,
              thickness: 3,
              height: 0,
              indent: 23,
              endIndent: 23,
            ),
            SizedBox(height: 20),

            _ChatCard(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            }),

            SizedBox(height: 20),

            // Botón "ESCOGER UN TEMA"
            SizedBox(height: 40),

            // Sección "Mis últimas sesiones"
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mis últimas sesiones',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConversacionesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Ver todas',
                      style: TextStyle(fontSize: 16, color: Color(0xFF2E86AB), fontFamily: 'Fredoka'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Cards de sesiones
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Card Conversaciones
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConversacionesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Conversaciones',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                                height: 1.2,
                                fontFamily: 'Fredoka',
                              ),
                            ),
                            SizedBox(height: 23),
                            Container(
                              width: 90,
                              height: 95,
                              decoration: BoxDecoration(
                                color: Color(0xFF87CEEB),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/conversaciones.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Card Progreso de las Actividad - CON NAVEGACIÓN
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActivitiesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Progreso de las\nActividades',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                                height: 1.2,
                                fontFamily: 'Fredoka',
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              width: 100,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color(0xFF87CEEB),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/medalla.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E3A4A) : const Color(0xFF87CEEB);
    final iconBg = isDark ? const Color(0xFF2E5568) : Colors.white;
    final iconColor = isDark ? const Color(0xFF90CAF9) : const Color(0xFF4A9DC5);
    final titleColor = isDark ? const Color(0xFF90CAF9) : Colors.white;
    final subtitleColor = isDark ? const Color(0xFF64B5F6) : Colors.white70;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.3)
        : const Color(0xFF87CEEB).withOpacity(0.4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(Icons.forum_rounded, color: iconColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Quieres hablar\nconmigo?',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Iniciar conversación',
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(Icons.arrow_forward_rounded, color: iconColor, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
