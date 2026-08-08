import 'package:flutter/material.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  int _selectedLevel = 1;
  final List<Map<String, String>> poses = [
    {
      'name': 'Asana del Loto',
      'duration': '5 min',
      'description': 'Pose de meditación fundamenta',
    },
    {
      'name': 'Cobra',
      'duration': '3 min',
      'description': 'Estira el pecho y abdomen',
    },
    {
      'name': 'Gato-Vaca',
      'duration': '4 min',
      'description': 'Calienta la columna',
    },
    {
      'name': 'Árbol',
      'duration': '3 min',
      'description': 'Mejora el equilibrio',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1E3A4A) : const Color(0xFF87CEEB);
    final shadowColor = isDark 
        ? Colors.black.withValues(alpha: 0.3) 
        : const Color(0xFF87CEEB).withValues(alpha: 0.4);
    final onCardColor = isDark ? const Color(0xFF90CAF9) : Colors.white;
    final secondaryTextColor = isDark ? const Color(0xFF64B5F6) : Colors.white70;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          '🧘 Yoga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            fontFamily: 'Fredoka',
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            color: colorScheme.outlineVariant,
            thickness: 1,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Selector de nivel
              Text(
                'Nivel de Dificultad:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLevelButton(1, 'Principiante'),
                  _buildLevelButton(2, 'Intermedio'),
                  _buildLevelButton(3, 'Avanzado'),
                ],
              ),
              const SizedBox(height: 32),
              // Resumen de sesión (Información centrada en tarjeta)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Sesión de Yoga Personalizada',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: onCardColor,
                        fontFamily: 'Fredoka',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Prepárate para conectar mente y cuerpo',
                      style: TextStyle(
                        fontSize: 15,
                        color: secondaryTextColor,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Fredoka',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Lista de poses
              Text(
                'Poses para esta sesión:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ...poses.map((pose) => _buildPoseCard(pose)),
              const SizedBox(height: 32),
              // Botón de inicio
              SizedBox(
                width: double.infinity,
                child: _ActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          '¡Iniciando sesión de Yoga!',
                          style: TextStyle(fontFamily: 'Fredoka'),
                        ),
                        backgroundColor: colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  },
                  label: 'Iniciar Sesión',
                  icon: Icons.spa_rounded,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(int level, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fredoka',
          ),
        ),
      ),
    );
  }

  Widget _buildPoseCard(Map<String, String> pose) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pose['name']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⏱️ ${pose['duration']!}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                    fontFamily: 'Fredoka',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pose['description']!,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Fredoka',
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const _ActionButton({
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

