import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        title: Text(
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
              Text(
                'Duración de la sesión:',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  10,
                  20,
                  30,
                  45,
                ].map((duration) => _buildDurationButton(duration)).toList(),
              ),
              SizedBox(height: 24.h),
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
                    Text(
                      'Calorías estimadas a quemar:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '$_burnedCalories kcal',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Lista de ejercicios
              Text(
                'Ejercicios disponibles:',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...exercises.map((exercise) => _buildExerciseCard(exercise)),
              SizedBox(height: 24.h),
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
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
                : [
                    Theme.of(context).colorScheme.surfaceContainerLow,
                    Theme.of(context).colorScheme.outlineVariant,
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$duration min',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
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
        color: const Color(0xFFE53935).withValues(alpha: 0.1),
        border: Border.all(color: const Color(0xFFE53935), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(exercise['emoji'], style: TextStyle(fontSize: 28.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              exercise['name'],
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '${exercise['cal']} kcal/min',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
