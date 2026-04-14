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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text(
          '🧘 Yoga',
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
              // Selector de nivel
              const Text(
                'Nivel de Dificultad:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLevelButton(1, 'Principiante'),
                  _buildLevelButton(2, 'Intermedio'),
                  _buildLevelButton(3, 'Avanzado'),
                ],
              ),
              const SizedBox(height: 24),
              // Lista de poses
              const Text(
                'Poses para esta sesión:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...poses.map((pose) => _buildPoseCard(pose)).toList(),
              const SizedBox(height: 24),
              // Botón de inicio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Iniciando sesión de Yoga!'),
                        backgroundColor: Color(0xFF4CAF50),
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

  Widget _buildLevelButton(int level, String label) {
    bool isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [const Color(0xFF4CAF50), const Color(0xFF81C784)]
                : [Colors.grey[300]!, Colors.grey[400]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPoseCard(Map<String, String> pose) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pose['name']!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(pose['description']!, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            '⏱️ ${pose['duration']!}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
