import 'package:flutter/material.dart';

class PhysicalActivityScreen extends StatefulWidget {
  const PhysicalActivityScreen({super.key});

  @override
  State<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  int _selectedDuration = 30;
  int _burnedCalories = 0;

  final List<Map<String, dynamic>> exercises = [
    {'name': 'Correr', 'cal': 10, 'emoji': '🏃'},
    {'name': 'Nadar', 'cal': 12, 'emoji': '🏊'},
    {'name': 'Ciclismo', 'cal': 9, 'emoji': '🚴'},
    {'name': 'Caminar', 'cal': 5, 'emoji': '🚶'},
    {'name': 'Boxeo', 'cal': 14, 'emoji': '🥊'},
  ];

  void _calculateCalories(int duration) {
    int total = 0;
    for (var exercise in exercises) {
      total += (exercise['cal'] as int) * (duration / 10).toInt();
    }
    setState(() {
      _selectedDuration = duration;
      _burnedCalories = total;
    });
  }

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
          '💪 Actividad Física',
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
              // Selector de duración
              Text(
                'Duración de la sesión:',
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
                  10,
                  20,
                  30,
                  45,
                ].map((duration) => _buildDurationButton(duration)).toList(),
              ),
              const SizedBox(height: 32),
              // Calorías quemadas
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
                      'Calorías estimadas a quemar:',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontFamily: 'Fredoka',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_burnedCalories kcal',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: onCardColor,
                        fontFamily: 'Fredoka',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Lista de ejercicios
              Text(
                'Ejercicios disponibles:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ...exercises.map((exercise) => _buildExerciseCard(exercise)),
              const SizedBox(height: 32),
              // Botón de inicio
              SizedBox(
                width: double.infinity,
                child: _ActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sesión de $_selectedDuration min iniciada!',
                          style: const TextStyle(fontFamily: 'Fredoka'),
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
                  icon: Icons.play_arrow_rounded,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationButton(int duration) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isSelected = _selectedDuration == duration;
    return GestureDetector(
      onTap: () => _calculateCalories(duration),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
          '$duration min',
          style: TextStyle(
            color: isSelected ? Colors.white : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fredoka',
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Text(exercise['emoji'], style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              exercise['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka',
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${exercise['cal']} kcal/min',
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

