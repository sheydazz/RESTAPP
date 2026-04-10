import 'package:flutter/material.dart';
import 'package:rest/features/progress/screens/globalprogress_screen.dart';
import 'package:rest/core/services/personal_progress_service.dart';
import '../../settings/screens/settings_screen.dart';
import '../../help/screens/help_screen.dart';
import '../../../core/services/user_session.dart';

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key});

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  final PersonalProgressService _personalService = PersonalProgressService();

  bool _loading = true;
  bool _activatingStreak = false;
  String? _error;
  PersonalDashboardSummary? _data;

  @override
  void initState() {
    super.initState();
    _loadPersonalData();
  }

  Future<void> _loadPersonalData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _personalService.fetchPantallaPersonal();
      if (!mounted) return;
      setState(() {
        _data = result;
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

  Future<void> _activarRachaDiaria() async {
    if (_activatingStreak) return;
    setState(() => _activatingStreak = true);

    try {
      final result = await _personalService.activarRachaDiaria();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.mensaje),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );

      await _loadPersonalData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo activar la estrella diaria: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _activatingStreak = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final diasTrabajados = _data?.diasTrabajadosEnMi ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPersonalData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                Divider(
                  color: Colors.grey[400],
                  thickness: 3,
                  height: 0,
                  indent: 23,
                  endIndent: 23,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'He trabajado $diasTrabajados días en mí',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                      fontFamily: 'Fredoka',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                if (_loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: CircularProgressIndicator(),
                  )
                else if (_error != null)
                  _ErrorPanel(error: _error!, onRetry: _loadPersonalData)
                else ...[
                  _buildStreakCard(context),
                  const SizedBox(height: 16),
                  _buildFrequentMoodCard(),
                  _buildFrequentEmotionsCard(),
                  _buildMoodEvolutionCard(),
                  _buildCreativeChallengeCard(),
                ],

                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF87CEEB),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/normalrest.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '¡Hola! ${UserSession.displayName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E86AB),
                fontFamily: 'Fredoka',
              ),
            ),
          ),
          _CircleIconAction(
            imagePath: 'assets/images/config.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          _CircleIconAction(
            imagePath: 'assets/images/salvavidas.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    final data = _data;
    if (data == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GlobalProgressScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFFF7FEFF), Color(0xFFEAF7FF)],
          ),
          border: Border.all(color: const Color(0xFF2F9FE8), width: 2),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.semanaActual
                  .map(
                    (day) => _DayItem(
                      day: day.dia,
                      active: day.estrellaActivada,
                      completed: day.registroEmocional,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _MiniBadge(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Racha: ${data.rachaActual}',
                  bgColor: const Color(0xFFFFF4E5),
                  fgColor: const Color(0xFFE36A10),
                ),
                const SizedBox(width: 8),
                _MiniBadge(
                  icon: Icons.auto_awesome_rounded,
                  label: 'Estrellas: ${data.estrellasRachaTotal}',
                  bgColor: const Color(0xFFFFF8E1),
                  fgColor: const Color(0xFFB77900),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: data.puedeActivarEstrellaHoy && !_activatingStreak
                    ? _activarRachaDiaria
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFB2DFDB),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Fredoka',
                  ),
                ),
                icon: _activatingStreak
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.star_rounded),
                label: Text(
                  data.estrellaHoyActivada
                      ? 'Estrella de hoy ya activada'
                      : data.puedeActivarEstrellaHoy
                      ? 'Activar estrella diaria'
                      : 'Completa tu registro emocional de hoy',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Activa tu estrella diaria para mantener la racha y sumar premios.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A5F),
                fontFamily: 'Fredoka',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequentMoodCard() {
    final estado = _data?.estadoAnimoMasFrecuente;

    final content = estado == null
        ? 'Aún no hay registros suficientes para detectar tu estado dominante.'
        : 'Tu estado más frecuente ha sido ${estado.nombre} (${estado.total} registros).';

    return _InfoCard(
      title: 'Estado de ánimo más frecuente',
      content: content,
      icon: Icons.favorite_rounded,
      iconColor: const Color(0xFFE53935),
    );
  }

  Widget _buildFrequentEmotionsCard() {
    final emociones = _data?.emocionesFrecuentes ?? const <FrequentMood>[];

    final content = emociones.isEmpty
        ? 'No se han registrado emociones suficientes en tus sesiones.'
        : emociones.map((e) => '${e.nombre} (${e.total})').join('  •  ');

    return _InfoCard(
      title: 'Emociones más frecuentes',
      content: content,
      icon: Icons.emoji_emotions_rounded,
      iconColor: const Color(0xFFFB8C00),
    );
  }

  Widget _buildMoodEvolutionCard() {
    final evo = _data?.evolucionEstadoAnimo;
    final serie = evo?.serieUltimos7Dias ?? const <EvolutionPoint>[];

    String tendenciaTexto(String tendencia) {
      if (tendencia == 'subiendo') return 'Vas mejorando esta semana.';
      if (tendencia == 'bajando')
        return 'Tu semana va exigente, cuídate más hoy.';
      return 'Tu estado se mantiene estable.';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2F9FE8), width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.show_chart_rounded, color: Color(0xFF2F9FE8)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Evolución del estado de ánimo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                    fontFamily: 'Fredoka',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            evo == null
                ? 'Aún no hay evolución para mostrar.'
                : tendenciaTexto(evo.tendencia),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          if (serie.isEmpty)
            const Text(
              'No se han registrado estados de ánimo en el periodo seleccionado.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            )
          else
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: serie.map((point) {
                  final safe = point.promedio.clamp(0.0, 5.0);
                  final barHeight = 8.0 + (safe * 10.0);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DB6AC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCreativeChallengeCard() {
    final data = _data;
    if (data == null) return const SizedBox.shrink();

    String reto;
    if (data.puedeActivarEstrellaHoy) {
      reto =
          'Reto del día: activa tu estrella diaria y escribe una línea en tu diario.';
    } else if (data.estrellaHoyActivada) {
      reto = 'Excelente: ya completaste tu reto de hoy. ¡Sostén la constancia!';
    } else {
      reto =
          'Te falta registrar tu estado emocional de hoy para desbloquear tu estrella.';
    }

    return _InfoCard(
      title: 'Reto personal inteligente',
      content: reto,
      icon: Icons.lightbulb_rounded,
      iconColor: const Color(0xFF8E24AA),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String day;
  final bool active;
  final bool completed;

  const _DayItem({
    required this.day,
    this.active = false,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (active)
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 24)
        else if (completed)
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF26A69A),
            size: 24,
          )
        else
          const Icon(
            Icons.radio_button_unchecked,
            color: Colors.grey,
            size: 24,
          ),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2F9FE8), width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                    fontFamily: 'Fredoka',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconAction extends StatelessWidget {
  const _CircleIconAction({required this.imagePath, required this.onTap});

  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF87CEEB),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.fgColor,
  });

  final IconData icon;
  final String label;
  final Color bgColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fgColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: fgColor,
              fontFamily: 'Fredoka',
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Column(
        children: [
          const Text(
            'No se pudo cargar tu pantalla personal.',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFB71C1C),
            ),
          ),
          const SizedBox(height: 8),
          Text(error, style: const TextStyle(color: Color(0xFFB71C1C))),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
