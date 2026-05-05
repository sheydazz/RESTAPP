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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        title: const Text(
          '💪 Actividad Física',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de duración
              const Text(
                'Duración de la sesión:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  10,
                  20,
                  30,
                  45,
                ].map((duration) => _buildDurationButton(duration)).toList(),
              ),
              const SizedBox(height: 24),
              // Calorías quemadas
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFEF5350)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Calorías estimadas a quemar:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_burnedCalories kcal',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Lista de ejercicios
              const Text(
                'Ejercicios disponibles:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...exercises
                  .map((exercise) => _buildExerciseCard(exercise))
                  .toList(),
              const SizedBox(height: 24),
              // Botón de inicio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sesión de $_selectedDuration min iniciada!',
                        ),
                        backgroundColor: const Color(0xFFE53935),
                      ),
                    );
                  },
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationButton(int duration) {
    bool isSelected = _selectedDuration == duration;
    return GestureDetector(
      onTap: () => _calculateCalories(duration),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [const Color(0xFFE53935), const Color(0xFFEF5350)]
                : [Theme.of(context).colorScheme.surfaceContainerLow, Theme.of(context).colorScheme.outlineVariant],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$duration min',
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withOpacity(0.1),
        border: Border.all(color: const Color(0xFFE53935), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(exercise['emoji'], style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              exercise['name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '${exercise['cal']} kcal/min',
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
