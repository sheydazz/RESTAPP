import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rest/core/routes/app_routes.dart';
import 'package:rest/core/services/diary_service.dart';

class MisCapitulosScreen extends StatefulWidget {
  const MisCapitulosScreen({super.key});

  @override
  State<MisCapitulosScreen> createState() => _MisCapitulosScreenState();
}

class _MisCapitulosScreenState extends State<MisCapitulosScreen> {
  final DiaryService _diaryService = DiaryService();

  bool _loading = true;
  String? _error;
  List<DiaryEntry> _entries = const [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _diaryService.fetchEntries();
      if (!mounted) return;
      setState(() {
        _entries = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
    );

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // header
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
                            gradient: gradient,
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

                      ShaderMask(
                        shaderCallback: (bounds) =>
                            gradient.createShader(bounds),
                        child: Text(
                          'Mis Capítulos',
                          style: GoogleFonts.fredoka(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // divisor
                  const SizedBox(height: 20),
                  Divider(
                    color: colorScheme.outlineVariant,
                    thickness: 3,
                    height: 0,
                    indent: 23,
                    endIndent: 23,
                  ),
                ],
              ),
            ),

            // 🔹 LISTA DE CAPÍTULOS
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 64,
                              color: Color(0xFF90A4AE),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No se pudieron cargar tus capitulos',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF546E7A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(
                                fontSize: 13,
                                color: const Color(0xFF90A4AE),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadEntries,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _entries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 80,
                            color: colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay capítulos aún',
                            style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onSurfaceVariant,
                              fontFamily: 'Fredoka',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Comienza escribiendo en tu diario',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                              fontFamily: 'Fredoka',
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadEntries,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final capitulo = _entries[index];
                          return _buildCapituloCard(
                            context,
                            capitulo.titulo,
                            capitulo.contenido,
                            DateFormat('dd/MM/yyyy').format(capitulo.fecha),
                            gradient,
                          );
                        },
                      ),
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
    RadialGradient gradient,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.capituloDetalle,
          arguments: {
            'titulo': titulo,
            'descripcion': descripcion,
            'fecha': fecha,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(2), // gradiente
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                titulo,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              // descrip
              Text(
                descripcion,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // date
              Text(
                fecha,
                style: GoogleFonts.fredoka(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
