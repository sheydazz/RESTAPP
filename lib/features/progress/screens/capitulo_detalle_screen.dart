import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.titulo ?? '');
    _descripcionController = TextEditingController(text: widget.descripcion ?? '');
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
            children: [
              // Header con botón de cerrar
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7DD3E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Formulario
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF7DD3E8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Campo Título
                      TextField(
                        controller: _tituloController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Fredoka',
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Titulo......',
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Fredoka',
                            color: Colors.black87,
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
            ],
          ),
        ),
      ),
    );
  }
}