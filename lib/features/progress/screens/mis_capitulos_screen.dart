import 'package:flutter/material.dart';

class MisCapitulosScreen extends StatelessWidget {
  const MisCapitulosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // test
    final capitulos = [
      {
        'titulo': 'Me duele',
        'descripcion': 'Puede esté pasando en mis días normales...',
        'fecha': '10/03/2025',
      },
      {
        'titulo': 'Me duele',
        'descripcion': 'Puede esté pasando en mis días normales...',
        'fecha': '10/03/2025',
      },
      {
        'titulo': 'Me duele',
        'descripcion': 'Puede esté pasando en mis días normales...',
        'fecha': '10/03/2025',
      },
      {
        'titulo': 'Me duele',
        'descripcion': 'Puede esté pasando en mis días normales...',
        'fecha': '10/03/2025',
      },
      {
        'titulo': 'Me duele',
        'descripcion': 'Puede esté pasando en mis días normales...',
        'fecha': '10/03/2025',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // cabezs
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
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
                      const SizedBox(width: 16),
                      const Text(
                        'Mis Capítulos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7DD3E8),
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                  ),
                ],
              ),
            ),

            // caps
            Expanded(
              child: capitulos.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay capítulos aún',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontFamily: 'Fredoka',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza escribiendo en tu diario',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontFamily: 'Fredoka',
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: capitulos.length,
                itemBuilder: (context, index) {
                  return _buildCapituloCard(
                    context,
                    capitulos[index]['titulo']!,
                    capitulos[index]['descripcion']!,
                    capitulos[index]['fecha']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapituloCard(
      BuildContext context,
      String titulo,
      String descripcion,
      String fecha,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/capitulo-detalle',
          arguments: {
            'titulo': titulo,
            'descripcion': descripcion,
            'fecha': fecha,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF7DD3E8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Fredoka',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Fredoka',
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              fecha,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka',
              ),
            ),
          ],
        ),
      ),
    );
  }
}