import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rest/core/services/progress_service.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final ProgressService _progressService = ProgressService();

  bool _loading = true;
  bool _sending = false;
  String? _error;
  DailyActivitiesSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _progressService.fetchActividadesDiarias();
      if (!mounted) return;
      setState(() {
        _summary = result;
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

  Future<void> _complete(DailyActivity activity) async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await _progressService.completarActividadDiaria(opcionId: activity.id);
      await _loadActivities();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actividad completada: ${activity.nombre}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo completar: $e')));
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = _summary?.pendientes ?? const <DailyActivity>[];
    final hechas = _summary?.hechas ?? const <DailyActivity>[];
    final formato = DateFormat('dd/MM/yyyy');
    final hoy = formato.format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0BBDAC), Color(0xFF6110E8)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Color(0xFF0BBDAC), Color(0xFF6110E8)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          'Mis Actividades',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30), // Para balancear el espacio de la X
                ],
              ),
            ),

            Divider(
              color: Colors.grey[400],
              thickness: 2,
              height: 0,
              indent: 16,
              endIndent: 16,
            ),

            SizedBox(height: 20),

            // Texto motivacional
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Fredoka',
                  ),
                  children: [
                    TextSpan(text: '⭐ '),
                    TextSpan(
                      text:
                          'Realiza las actividades y reclama tus premios personalizados!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Grid de actividades
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No se pudo cargar actividades',
                            style: TextStyle(color: Colors.red[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _loadActivities,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(
                          2,
                        ), // Grosor del borde con gradiente
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0BBDAC), Color(0xFF6110E8)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            children: [
                              if (pendientes.isEmpty && hechas.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'No hay actividades disponibles hoy.',
                                  ),
                                ),
                              ...pendientes
                                  .map(
                                    (a) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: _buildActivityCard(
                                        a.nombre,
                                        'assets/images/Play.png',
                                        hoy,
                                        completed: false,
                                        onAction: () => _complete(a),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              ...hechas
                                  .map(
                                    (a) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: _buildActivityCard(
                                        a.nombre,
                                        'assets/images/medalla.png',
                                        hoy,
                                        completed: true,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String imagePath,
    String date, {
    bool completed = false,
    VoidCallback? onAction,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen de la actividad
              Container(
                width: 80,
                height: 80,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              SizedBox(height: 12),

              // Título de la actividad
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: completed || onAction == null || _sending
                      ? null
                      : onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: completed
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF0BBDAC),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: Text(completed ? 'Completada' : 'Completar'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Fecha de vencimiento fuera de la tarjeta
        Text(
          'Vence el:',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
