import 'package:flutter/material.dart';

class GlobalProgressScreen extends StatelessWidget {
  const GlobalProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> agostoDays = [
      {"day": 1, "emoji": "assets/images/smilerest.jpg"},
      {"day": 2, "emoji": "assets/images/sadrest.jpg"},
      {"day": 3, "emoji": "assets/images/smilerest.jpg"},
      {"day": 4, "emoji": "assets/images/sadrest.jpg"},
      {"day": 5, "emoji": "assets/images/normalrest.jpg"},
      {"day": 6, "emoji": "assets/images/goodrest.jpg"},
      {"day": 7, "emoji": "assets/images/normalrest.jpg"},
      {"day": 8, "emoji": "assets/images/sadrest.jpg"},
      {"day": 9, "emoji": "assets/images/goodrest.jpg"},
      {"day": 10, "emoji": "assets/images/sadrest.jpg"},
      {"day": 11, "emoji": "assets/images/goodrest.jpg"},
    ];

    final List<Map<String, dynamic>> septiembreDays = [
      {"day": 1, "emoji": "assets/images/smilerest.jpg"},
      {"day": 2, "emoji": "assets/images/normalrest.jpg"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cerrar y título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.blue, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Registro Global",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 40), // para balancear
                ],
              ),
              const SizedBox(height: 20),

              // Switch Mes/Año
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.lightBlue, Colors.blue],
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSwitchButton("Mes", true),
                    _buildSwitchButton("Año", false),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Agosto
              _buildMonthSection("Agosto", 31, agostoDays, startOffset: 5),
              const SizedBox(height: 30),

              // Septiembre
              _buildMonthSection("Septiembre", 30, septiembreDays, startOffset: 0),
            ],
          ),
        ),
      ),
    );
  }

  // Botón del switch Mes/Año
  Widget _buildSwitchButton(String text, bool active) {
    return Container(
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: active ? Colors.blue : Colors.white,
        ),
      ),
    );
  }

  // Sección de un mes
  Widget _buildMonthSection(String month, int totalDays, List<Map<String, dynamic>> emojiDays,
      {int startOffset = 0}) {
    return Column(
      children: [
        Text(
          month,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Encabezado de semana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("LUNES", style: TextStyle(fontWeight: FontWeight.bold, fontSize  : 7),),
            Text("MARTES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),),
            Text("MIERCOLES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),),
            Text("JUEVES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),),
            Text("VIERNES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),),
            Text("SABADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),),
            Text("DOMINGO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),),
          ],
        ),
        const SizedBox(height: 10),

        // Calendario
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 filas x 7 columnas
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              int dayNumber = index - startOffset + 1;
              if (dayNumber <= 0 || dayNumber > totalDays) {
                return Container(); // vacío
              }

              // busca si este día tiene emoji
              Map<String, dynamic>? emojiDay;
              try {
                emojiDay = emojiDays.firstWhere(
                  (e) => e["day"] == dayNumber,
                );
              } catch (e) {
                emojiDay = null;
              }

              return Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Text(
                        "$dayNumber",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    if (emojiDay != null)
                      Center(
                        child: Image.asset(
                          emojiDay['emoji'],
                          width: 40,
                          height: 40,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
