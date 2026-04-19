import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
import 'package:rest/core/services/emotion_service.dart';
import 'package:rest/core/services/progress_service.dart';
import 'package:rest/core/services/user_session.dart';
import 'package:rest/features/progress/screens/emotional_calendar_screen.dart';
import 'package:rest/features/relax/screens/jokes_screen.dart';
import 'package:rest/features/relax/screens/music_screen.dart';
import 'package:rest/features/relax/screens/physical_activity_screen.dart';
import 'package:rest/features/relax/screens/yoga_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final EmotionService _emotionService = EmotionService();
  final ProgressService _progressService = ProgressService();

  bool _loadingWeekly = true;
  bool _loadingActivities = true;
  bool _loadingTechniques = true;
  bool _loadingRewards = true;
  int? _sendingActivityId;
  int? _sendingRewardId;

  String? _weeklyError;
  String? _activitiesError;
  String? _techniquesError;
  String? _rewardsError;

  final Map<String, num> _weeklyByDate = {};
  DailyActivitiesSummary? _actividades;
  List<RelaxTechnique> _tecnicas = const [];
  RewardsCatalogSummary? _rewardsCatalog;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadWeekly(),
      _loadDailyActivities(),
      _loadTechniques(),
      _loadRewardsCatalog(),
    ]);
  }

  Future<void> _loadWeekly() async {
    setState(() {
      _loadingWeekly = true;
      _weeklyError = null;
    });

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final start = today.subtract(const Duration(days: 5));
      final end = today.add(const Duration(days: 5));

      final result = await _emotionService.fetchCalendarioEmocional(
        inicio: start,
        fin: end,
      );

      final mapped = <String, num>{};
      for (final item in result) {
        final fecha = (item['fecha'] ?? '').toString();
        final prom = item['promedio'] ?? item['promedio_emocional'];
        if (fecha.isEmpty || prom == null) continue;
        final parsed = prom is num ? prom : num.tryParse(prom.toString());
        final key = _normalizeApiDateKey(fecha);
        if (parsed != null && key != null) {
          mapped[key] = parsed;
        }
      }

      final todayKey = _toDateKey(today);
      final tomorrowKey = _toDateKey(today.add(const Duration(days: 1)));
      final hasToday = mapped.containsKey(todayKey);
      final hasTomorrow = mapped.containsKey(tomorrowKey);

      // Fallback para cuando backend viene corrido +1 día por zona horaria.
      if (!hasToday && hasTomorrow) {
        final shifted = <String, num>{};
        for (final entry in mapped.entries) {
          final shiftedKey = _shiftDateKey(entry.key, days: -1);
          shifted[shiftedKey] = entry.value;
        }
        mapped
          ..clear()
          ..addAll(shifted);
      }

      if (!mounted) return;
      setState(() {
        _weeklyByDate
          ..clear()
          ..addAll(mapped);
        _loadingWeekly = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _weeklyError = e.toString();
        _loadingWeekly = false;
      });
    }
  }

  Future<void> _loadDailyActivities() async {
    setState(() {
      _loadingActivities = true;
      _activitiesError = null;
    });

    try {
      final data = await _progressService.fetchActividadesDiarias();
      if (!mounted) return;
      setState(() {
        _actividades = data;
        _loadingActivities = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _activitiesError = e.toString();
        _loadingActivities = false;
      });
    }
  }

  Future<void> _loadTechniques() async {
    setState(() {
      _loadingTechniques = true;
      _techniquesError = null;
    });

    try {
      final data = await _progressService.fetchTecnicasRelajacion();
      if (!mounted) return;
      setState(() {
        _tecnicas = data;
        _loadingTechniques = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _techniquesError = e.toString();
        _loadingTechniques = false;
      });
    }
  }

  Future<void> _loadRewardsCatalog() async {
    setState(() {
      _loadingRewards = true;
      _rewardsError = null;
    });

    try {
      final data = await _progressService.fetchRewardsCatalog();
      if (!mounted) return;
      setState(() {
        _rewardsCatalog = data;
        _loadingRewards = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _rewardsError = e.toString();
        _loadingRewards = false;
      });
    }
  }

  Future<void> _requestReward(RewardItem reward) async {
    if (_sendingRewardId != null) return;
    setState(() => _sendingRewardId = reward.id);

    try {
      await _progressService.requestReward(premioId: reward.id);
      await _loadRewardsCatalog();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solicitud enviada: ${reward.nombre}. Bienestar Universitario recibio el correo.',
          ),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo solicitar premio: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sendingRewardId = null);
      }
    }
  }

  Future<void> _completeActivity(DailyActivity activity) async {
    if (_sendingActivityId != null) return;
    setState(() => _sendingActivityId = activity.id);

    try {
      await _progressService.completarActividadDiaria(opcionId: activity.id);
      await Future.wait([_loadDailyActivities(), _loadRewardsCatalog()]);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Actividad completada: ${activity.nombre}'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo completar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sendingActivityId = null);
      }
    }
  }

  Future<void> _registrarTecnicaYEntrar(
    RelaxTechnique tecnica,
    Widget screen,
  ) async {
    if (tecnica.id > 0) {
      try {
        await _progressService.registrarPracticaTecnica(opcionId: tecnica.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Práctica registrada: ${tecnica.nombre}'),
            backgroundColor: const Color(0xFF1565C0),
          ),
        );
      } catch (_) {
        // Si falla el registro no bloquea navegación
      }
    }

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildRegistroEmocional(context),
                  const SizedBox(height: 24),
                  _buildActividadesDiarias(),
                  const SizedBox(height: 24),
                  _buildMiDiario(context),
                  const SizedBox(height: 24),
                  _buildTecnicasRelajacion(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildHeaderIcon(
              imagePath: 'assets/images/config.png',
              fallback: Icons.settings,
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            const SizedBox(width: 8),
            _buildHeaderIcon(
              imagePath: 'assets/images/salvavidas.png',
              fallback: Icons.help_outline,
              onTap: () => Navigator.pushNamed(context, AppRoutes.help),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey[400],
          thickness: 3,
          height: 0,
          indent: 23,
          endIndent: 23,
        ),
      ],
    );
  }

  Widget _buildHeaderIcon({
    required String imagePath,
    required IconData fallback,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF87CEEB),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) => Icon(fallback, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistroEmocional(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final quickDays = List.generate(8, (i) => today.add(Duration(days: i - 2)));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7DD3E8), Color(0xFF9FE6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Registro Emocional',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Fredoka',
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmotionalCalendarScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Ver Todo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Resumen semanal rápido',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: _loadingWeekly
                ? const SizedBox(
                    height: 72,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _weeklyError != null
                ? Column(
                    children: [
                      Text(
                        'No se pudo cargar el semanal',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      TextButton(
                        onPressed: _loadWeekly,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: quickDays.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final date = quickDays[index];
                        final key = _toDateKey(date);
                        final prom = _weeklyByDate[key];
                        final isToday =
                            date.year == today.year &&
                            date.month == today.month &&
                            date.day == today.day;
                        return _weekEmotionChip(date, prom, isToday: isToday);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _weekEmotionChip(
    DateTime date,
    num? promedio, {
    required bool isToday,
  }) {
    final dayNames = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    final hasData = promedio != null;
    final asset = hasData
        ? _assetFromPromedio(promedio)
        : 'assets/images/star.png';

    return Container(
      width: 78,
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFFDDF1FF) : const Color(0xFFF3FBFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? const Color(0xFF2F9FE8) : const Color(0xFFD2F0FF),
          width: isToday ? 1.8 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayNames[date.weekday - 1],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E3A5F),
              fontFamily: 'Fredoka',
            ),
          ),
          if (isToday)
            const Text(
              'HOY',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1565C0),
                fontFamily: 'Fredoka',
              ),
            ),
          const SizedBox(height: 2),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                asset,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.emoji_emotions),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hasData ? promedio.toStringAsFixed(1) : '--',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF34495E),
              fontFamily: 'Fredoka',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActividadesDiarias() {
    final hechas = _actividades?.hechas ?? const <DailyActivity>[];
    final pendientes = _actividades?.pendientes ?? const <DailyActivity>[];
    final estrellasHoy = _actividades?.totalHechas ?? 0;
    final metaDiaria = (_actividades?.totalObjetivoDiario ?? 5).clamp(1, 999);
    final estrellasMes = _actividades?.estrellasMesActual ?? 0;
    final metaMes = (_actividades?.metaEstrellasMesActual ?? 150).clamp(
      1,
      9999,
    );
    final progresoMes = (estrellasMes / metaMes).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis actividades diarias',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFF7FEFF), Color(0xFFEAF7FF)],
            ),
            border: Border.all(color: const Color(0xFF7DD3E8), width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: _loadingActivities
              ? const Center(child: CircularProgressIndicator())
              : _activitiesError != null
              ? Column(
                  children: [
                    Text(
                      'No se pudo cargar actividades',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    TextButton(
                      onPressed: _loadDailyActivities,
                      child: const Text('Reintentar'),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Progreso de hoy',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Fredoka',
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFA726),
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$estrellasHoy',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFBF6D00),
                                  fontFamily: 'Fredoka',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          onPressed: _showRewardsSheet,
                          icon: const Icon(
                            Icons.card_giftcard_rounded,
                            size: 18,
                          ),
                          label: const Text('Premios'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F7FF),
                            foregroundColor: const Color(0xFF1565C0),
                            textStyle: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: estrellasHoy / metaDiaria,
                        backgroundColor: const Color(0xFFCFEDFA),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF26A69A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$estrellasHoy de $metaDiaria completadas hoy. Objetivo: 5 actividades por dia.',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF455A64),
                        fontFamily: 'Fredoka',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFAEE),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFE1A8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: Color(0xFFEF8D00),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Estrellas del mes: $estrellasMes / $metaMes',
                                style: const TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF8A5200),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: progresoMes),
                            duration: const Duration(milliseconds: 850),
                            curve: Curves.easeOutCubic,
                            builder: (_, value, __) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  value: value,
                                  backgroundColor: const Color(0xFFFFEFD1),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFFFFB300),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pendientes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Fredoka',
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (pendientes.isEmpty)
                      _emptyHint('Ya completaste todas tus actividades de hoy')
                    else
                      ...pendientes
                          .take(5)
                          .map((a) => _activityItem(a, isDone: false)),
                    const SizedBox(height: 14),
                    const Text(
                      'Completadas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Fredoka',
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (hechas.isEmpty)
                      _emptyHint('Aún no has completado actividades')
                    else
                      ...hechas
                          .take(5)
                          .map((a) => _activityItem(a, isDone: true)),
                  ],
                ),
        ),
      ],
    );
  }

  void _showRewardsSheet() {
    final catalog = _rewardsCatalog;
    final estrellasDisponibles = catalog?.estrellasDisponibles ?? 0;
    final estrellasAcumuladas = catalog?.estrellasAcumuladas ?? 0;
    final estrellasReservadas = catalog?.estrellasReservadas ?? 0;
    final rewards = catalog?.premios ?? const <RewardItem>[];
    final solicitudes = catalog?.solicitudes ?? const <RewardRequest>[];
    final ratio = estrellasAcumuladas <= 0
        ? 0.0
        : (estrellasDisponibles / estrellasAcumuladas).clamp(0, 1).toDouble();

    final premiosPendientes = solicitudes
        .where((s) => s.estado.toLowerCase() == 'pendiente')
        .map((s) => s.premioNombre.toLowerCase())
        .toSet();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 54,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8E2EA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Premios del mes',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_loadingRewards)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_rewardsError != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No se pudo cargar catalogo de premios',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () async {
                              await _loadRewardsCatalog();
                              if (!mounted) return;
                              Navigator.pop(context);
                              _showRewardsSheet();
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Acumuladas: $estrellasAcumuladas  |  Reservadas: $estrellasReservadas  |  Disponibles: $estrellasDisponibles',
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF546E7A),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: ratio),
                            duration: const Duration(milliseconds: 850),
                            curve: Curves.easeOutQuart,
                            builder: (_, value, __) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      minHeight: 14,
                                      value: value,
                                      backgroundColor: const Color(0xFFE9F3FB),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color(0xFF2F9FE8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Estrellas disponibles para canjear: ${(value * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontFamily: 'Fredoka',
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E3A5F),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          if (rewards.isEmpty)
                            const Text(
                              'No hay premios activos por el momento.',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                color: Color(0xFF607D8B),
                              ),
                            )
                          else
                            ...rewards.map((reward) {
                              final alreadyPending = premiosPendientes.contains(
                                reward.nombre.toLowerCase(),
                              );
                              return _buildRewardCard(
                                reward: reward,
                                unlocked:
                                    reward.solicitarHabilitado &&
                                    !alreadyPending,
                                starsRemaining: reward.estrellasFaltantes,
                                isPending: alreadyPending,
                                onRequest: () => _requestReward(reward),
                              );
                            }),
                          if (solicitudes.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Solicitudes recientes',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...solicitudes
                                .take(3)
                                .map(
                                  (s) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      '• ${s.premioNombre} - ${s.estado.toUpperCase()}',
                                      style: const TextStyle(
                                        fontFamily: 'Fredoka',
                                        color: Color(0xFF455A64),
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRewardCard({
    required RewardItem reward,
    required bool unlocked,
    required int starsRemaining,
    required bool isPending,
    required VoidCallback onRequest,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFEFFFF7) : const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked ? const Color(0xFF4CAF50) : const Color(0xFFD9E8F6),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE8F3FF),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFF1D84B5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.nombre,
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reward.descripcion,
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    color: Color(0xFF607D8B),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPending
                      ? 'Ya tienes una solicitud pendiente para este premio'
                      : unlocked
                      ? 'Listo para canjear en Bienestar Universitario'
                      : 'Te faltan $starsRemaining estrellas',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w700,
                    color: isPending
                        ? const Color(0xFF1565C0)
                        : unlocked
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF8D6E63),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    onPressed:
                        (unlocked &&
                            !isPending &&
                            _sendingRewardId != reward.id)
                        ? onRequest
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: unlocked && !isPending
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFB0BEC5),
                      disabledBackgroundColor: const Color(0xFFCFD8DC),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: _sendingRewardId == reward.id
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Solicitar Premio'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${reward.estrellasRequeridas}★',
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w800,
                color: Color(0xFFBF6D00),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(DailyActivity item, {required bool isDone}) {
    final isSendingThisItem = _sendingActivityId == item.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1EFF8)),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            color: isDone ? const Color(0xFF2E7D32) : const Color(0xFF546E7A),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fredoka',
                  ),
                ),
                if (item.descripcion.isNotEmpty)
                  Text(
                    item.descripcion,
                    style: const TextStyle(
                      color: Color(0xFF607D8B),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (!isDone)
            ElevatedButton.icon(
              onPressed: isSendingThisItem
                  ? null
                  : () => _completeActivity(item),
              icon: isSendingThisItem
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.star_rounded, size: 18),
              label: Text(isSendingThisItem ? 'Completando...' : 'Completar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontFamily: 'Fredoka'),
              ),
            )
          else
            const Icon(Icons.star_rounded, color: Color(0xFFFFA726)),
        ],
      ),
    );
  }

  Widget _emptyHint(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF607D8B),
          fontWeight: FontWeight.w600,
          fontFamily: 'Fredoka',
        ),
      ),
    );
  }

  Widget _buildMiDiario(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mi diario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.miDiario),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7DD3E8), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset('assets/images/dairy.jpg', width: 110, height: 90),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Escribe aquí todas las cosas importantes de tu día',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTecnicasRelajacion(BuildContext context) {
    final sourceTechniques = _buildAllowedTechniques(_tecnicas);

    final mapped = sourceTechniques.map((t) {
      final tuple = _mapTechnique(t.nombre);
      return _TechniqueCardData(
        tecnica: t,
        imagePath: tuple.$1,
        screen: tuple.$2,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis técnicas de relajación',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFEAF9FF), Color(0xFFF6F9FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFF7DD3E8), width: 2),
          ),
          child: _loadingTechniques
              ? const Center(child: CircularProgressIndicator())
              : _techniquesError != null
              ? Column(
                  children: [
                    Text(
                      'No se pudieron cargar técnicas',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    TextButton(
                      onPressed: _loadTechniques,
                      child: const Text('Reintentar'),
                    ),
                  ],
                )
              : GridView.builder(
                  itemCount: mapped.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (_, index) {
                    final item = mapped[index];
                    return _techniqueCard(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _techniqueCard(_TechniqueCardData data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5FCFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: const Color(0xFFDCEFFA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A6EC7EE),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'API',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF00796B),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Fredoka',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.self_improvement,
                  color: Color(0xFF6BA7D9),
                  size: 42,
                ),
              ),
            ),
            Text(
              data.tecnica.nombre,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    _registrarTecnicaYEntrar(data.tecnica, data.screen),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: const Color(0xFF2F9FE8),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Practicar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Widget) _mapTechnique(String nombre) {
    final value = _normalizeText(nombre);
    if (value.contains('yoga')) {
      return ('assets/images/yoga.png', const YogaScreen());
    }
    if (value.contains('chiste')) {
      return ('assets/images/chistes.png', const JokesScreen());
    }
    if (value.contains('musi')) {
      return ('assets/images/musica.png', const MusicScreen());
    }
    if (value.contains('fisic') || value.contains('gim')) {
      return ('assets/images/gym.png', const PhysicalActivityScreen());
    }
    return ('assets/images/normalrest.jpg', const YogaScreen());
  }

  List<RelaxTechnique> _buildAllowedTechniques(List<RelaxTechnique> input) {
    RelaxTechnique? yoga;
    RelaxTechnique? chistes;
    RelaxTechnique? musica;
    RelaxTechnique? actividadFisica;

    for (final t in input) {
      final value = _normalizeText(t.nombre);
      if (yoga == null && value.contains('yoga')) {
        yoga = t;
      } else if (chistes == null && value.contains('chiste')) {
        chistes = t;
      } else if (musica == null && value.contains('musi')) {
        musica = t;
      } else if (actividadFisica == null &&
          (value.contains('fisic') || value.contains('gim'))) {
        actividadFisica = t;
      }
    }

    RelaxTechnique fallback(String nombre) => RelaxTechnique(
      id: 0,
      nombre: nombre,
      descripcion: 'Disponible en la app',
    );

    return [
      RelaxTechnique(
        id: yoga?.id ?? 0,
        nombre: 'Yoga',
        descripcion: yoga?.descripcion ?? 'Disponible en la app',
        imageUrl: yoga?.imageUrl,
      ),
      RelaxTechnique(
        id: chistes?.id ?? 0,
        nombre: 'Chistes',
        descripcion: chistes?.descripcion ?? 'Disponible en la app',
        imageUrl: chistes?.imageUrl,
      ),
      RelaxTechnique(
        id: actividadFisica?.id ?? 0,
        nombre: 'Actividad Física',
        descripcion:
            actividadFisica?.descripcion ??
            fallback('Actividad Física').descripcion,
        imageUrl: actividadFisica?.imageUrl,
      ),
      RelaxTechnique(
        id: musica?.id ?? 0,
        nombre: 'Escuchar Música',
        descripcion:
            musica?.descripcion ?? fallback('Escuchar Música').descripcion,
        imageUrl: musica?.imageUrl,
      ),
    ];
  }

  String? _normalizeApiDateKey(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return null;

    final parsed = DateTime.tryParse(clean);
    if (parsed != null) {
      final local = parsed.isUtc ? parsed.toLocal() : parsed;
      return _toDateKey(DateTime(local.year, local.month, local.day));
    }

    if (clean.length >= 10) {
      final iso = clean.substring(0, 10);
      final dateOnly = DateTime.tryParse(iso);
      if (dateOnly != null) {
        return _toDateKey(dateOnly);
      }
      return iso;
    }

    return null;
  }

  String _normalizeText(String input) {
    return input
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }

  String _toDateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  String _shiftDateKey(String key, {required int days}) {
    final parsed = DateTime.tryParse(key);
    if (parsed == null) return key;
    final shifted = parsed.add(Duration(days: days));
    return _toDateKey(shifted);
  }

  String _assetFromPromedio(num promedio) {
    if (promedio >= 3.3) return 'assets/images/goodrest.jpg';
    if (promedio >= 2.2) return 'assets/images/green_face.png';
    if (promedio >= 1.0) return 'assets/images/yellowrest.jpg';
    return 'assets/images/pink_face.png';
  }
}

class _TechniqueCardData {
  _TechniqueCardData({
    required this.tecnica,
    required this.imagePath,
    required this.screen,
  });

  final RelaxTechnique tecnica;
  final String imagePath;
  final Widget screen;
}
