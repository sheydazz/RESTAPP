import 'package:flutter/material.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  int _currentJoke = 0;
  bool _showPunchline = false;

  final List<Map<String, String>> jokes = [
    {
      'setup': '¿Por qué los pájaros no se pierden cuando vuelan?',
      'punchline': '¡Porque usan el Mapache!',
    },
    {
      'setup': '¿Qué dijo el número 0 al número 8?',
      'punchline': '¡Qué bonito cinturón!',
    },
    {
      'setup': '¿Cuál es el colmo para un electricista?',
      'punchline': '¡Que su hijo sea un desconectado!',
    },
    {
      'setup': '¿Qué se siente tener los ojos azules en un país de gatos?',
      'punchline': '¡Que todos piensen que eres un peluche!',
    },
    {
      'setup': '¿Por qué las ovejas no se pierden en la nieve?',
      'punchline': '¡Porque tienen GPS (Gps Pastadas)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFA000),
        title: const Text(
          '😂 Chistes',
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
            children: [
              const SizedBox(height: 24),
              // Tarjeta del chiste
              GestureDetector(
                onTap: () => setState(() => _showPunchline = !_showPunchline),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA000), Color(0xFFFFB74D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFA000).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        jokes[_currentJoke]['setup']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (_showPunchline)
                        Text(
                          jokes[_currentJoke]['punchline']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        const Text(
                          'Toca para ver la respuesta',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentJoke > 0
                        ? () => setState(() {
                            _currentJoke--;
                            _showPunchline = false;
                          })
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA000),
                    ),
                  ),
                  Text(
                    '${_currentJoke + 1}/${jokes.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    onPressed: _currentJoke < jokes.length - 1
                        ? () => setState(() {
                            _currentJoke++;
                            _showPunchline = false;
                          })
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Siguiente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA000),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
