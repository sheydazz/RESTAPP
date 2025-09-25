import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressScreen extends StatelessWidget {
  ProgressScreen({super.key});

  final List<Map<String, String>> weekData = [
    {"day": "Lunes", "icon": "assets/images/pink_face.svg"},
    {"day": "Martes", "icon": "assets/images/green_face.svg"},
    {"day": "Miércoles", "icon": "assets/images/pink_face.svg"},
    {"day": "Jueves", "icon": "assets/images/yellow_face.svg"},
    {"day": "Viernes", "icon": "assets/images/green_face.svg"},
    {"day": "Sábado", "icon": "assets/images/pink_face.svg"},
    {"day": "Domingo", "icon": "assets/images/yellow_face.svg"},
  ];

  final List<String> activities = [
    "Juega un rato",
    "Desahógate en el gimnasio",
    "Habla con una persona",
    "Sal a correr con música",
  ];

  final List<Map<String, String>> relaxTechniques = [
    {"name": "Yoga", "icon": "assets/images/yoga.svg"},
    {"name": "Chistes", "icon": "assets/images/chistes.svg"},
    {"name": "Juegos", "icon": "assets/images/juegos.svg"},
    {"name": "Escuchar Musica", "icon": "assets/images/musica.svg"},
    {"name": "Actividad Física", "icon": "assets/images/gym.svg"},
  ];


  @override
  Widget build(BuildContext context) {
    const purpleBorder = Color(0xFFB64CF6);
    const lightBlue = Color(0xFFE9F7FF);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (3 íconos SVG)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage("assets/images/goodrest.jpg"),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "¡Hola! Mari",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      _AssetIcon("assets/images/white_gear.svg", size: 30),
                      SizedBox(width: 12),
                      _AssetIcon("assets/images/float.svg", size: 30),
                      SizedBox(width: 12),
                      _AssetIcon("assets/images/chistes.svg", size: 30), // ícono decorativo
                    ],
                  )
                ],
              ),
              const SizedBox(height: 14),
              Container(height: 2, color: Colors.blue.shade200.withOpacity(.6)),
              const SizedBox(height: 16),

              // REGISTRO EMOCIONAL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCE6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "REGISTRO EMOCIONAL",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.purple.shade700,
                        letterSpacing: .5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weekData.map((d) {
                        return Column(
                          children: [
                            _AssetIcon(d["icon"]!, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              d["day"]!.substring(0, 3).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                "Mis actividades diarias",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: purpleBorder, width: 2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: List.generate(activities.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${i + 1}. ${activities[i]}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, size: 20, color: Colors.orange),
                              SizedBox(width: 2),
                              Icon(Icons.star, size: 20, color: Colors.orange),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Ver todas",
                    style: TextStyle(
                      color: Color(0xFF2E98FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // MI DIARIO  (SVG corregido)
              const Text(
                "Mi diario",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: purpleBorder, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const _AssetIcon("assets/images/dairy.svg", size: 90),
                      const SizedBox(height: 8),
                      const Text(
                        "¡Escribe aquí todas las cosas importantes de tu día!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // TÉCNICAS DE RELAJACIÓN
              const Text(
                "Mis técnicas de relajación",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: purpleBorder, width: 2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: relaxTechniques.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final t = relaxTechniques[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _AssetIcon(t["icon"]!, size: 56),
                          const SizedBox(height: 8),
                          Text(
                            t["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetIcon extends StatelessWidget {
  final String path;
  final double size;

  const _AssetIcon(this.path, {this.size = 28});

  @override
  Widget build(BuildContext context) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
