import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CapituloDetalleScreen extends StatefulWidget {
  final String? titulo;
  final String? descripcion;
  final String? fecha;

  const CapituloDetalleScreen({
    super.key,
    this.titulo,
    this.descripcion,
    this.fecha,
  });

  @override
  State<CapituloDetalleScreen> createState() => _CapituloDetalleScreenState();
}

class _CapituloDetalleScreenState extends State<CapituloDetalleScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;

  final RadialGradient _gradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
  );

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.titulo ?? '');
    _descripcionController =
        TextEditingController(text: widget.descripcion ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADER
              Row(
                children: [
                  // Botón atrás con gradiente
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: _gradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Texto "Capítulo" con gradiente
                  ShaderMask(
                    shaderCallback: (bounds) => _gradient.createShader(bounds),
                    child: Text(
                      'Capítulo',
                      style: GoogleFonts.fredoka(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // 🔸 Divider como en otras pantallas
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey[400],
                thickness: 3,
                height: 0,
                indent: 23,
                endIndent: 23,
              ),
              const SizedBox(height: 20),

              // 🔹 FORMULARIO
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(2), // borde gradiente
                  decoration: BoxDecoration(
                    gradient: _gradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        // Campo Título
                        TextField(
                          controller: _tituloController,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Título......',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Fredoka',
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const Divider(
                          color: Color(0xFFE0E0E0),
                          thickness: 1,
                        ),
                        const SizedBox(height: 8),

                        // Campo Descripción
                        Expanded(
                          child: TextField(
                            controller: _descripcionController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: GoogleFonts.fredoka(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Descripción......',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: 'Fredoka',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
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
      ),
    );
  }
}
