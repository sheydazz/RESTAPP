import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rest/core/services/emotion_service.dart';

class EmotionalCalendarScreen extends StatefulWidget {
  const EmotionalCalendarScreen({super.key});

  @override
  State<EmotionalCalendarScreen> createState() =>
      _EmotionalCalendarScreenState();
}

class _EmotionalCalendarScreenState extends State<EmotionalCalendarScreen> {
  final EmotionService _emotionService = EmotionService();

  final int _year = DateTime.now().year;
  bool _isLoading = true;
  String? _error;
  final Map<String, num> _byDate = {};

  @override
  void initState() {
    super.initState();
    _loadCalendar();
  }

  Future<void> _loadCalendar() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await initializeDateFormatting('es_ES');

      final start = DateTime(_year, 1, 1);
      final end = DateTime(_year, 12, 31);
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
        final key = _normalizeDateKey(fecha);
        if (parsed != null && key != null) {
          mapped[key] = parsed;
        }
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayKey = _toDateKey(today);
      final tomorrowKey = _toDateKey(today.add(const Duration(days: 1)));

      if (!mapped.containsKey(todayKey) && mapped.containsKey(tomorrowKey)) {
        final shifted = <String, num>{};
        for (final entry in mapped.entries) {
          shifted[_shiftDateKey(entry.key, days: -1)] = entry.value;
        }
        mapped
          ..clear()
          ..addAll(shifted);
      }

      if (!mounted) return;
      setState(() {
        _byDate
          ..clear()
          ..addAll(mapped);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCalendar,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildLegend(),
                const SizedBox(height: 18),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_error != null)
                  _buildError()
                else
                  ...List.generate(
                    12,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: _monthCard(index + 1),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Color(0xFF1E88E5), size: 28),
        ),
        const Spacer(),
        Text(
          'Registro Global $_year',
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E88E5),
            fontFamily: 'Fredoka',
          ),
        ),
        const Spacer(),
        const SizedBox(width: 28),
      ],
    );
  }

  Widget _buildLegend() {
    Widget item(String label, String asset) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              asset,
              width: 22,
              height: 22,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.emoji_emotions),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Fredoka',
              color: Color(0xFF37474F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFEAF4FF),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          item('Muy mal', 'assets/images/sadrest.jpg'),
          item('Mal', 'assets/images/yellowrest.jpg'),
          item('Normal', 'assets/images/normalrest.jpg'),
          item('Bien', 'assets/images/goodrest.jpg'),
          item('Excelente', 'assets/images/statesuperexcellent.png'),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        children: [
          Text(
            'No se pudo cargar tu calendario',
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _loadCalendar, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  Widget _monthCard(int month) {
    final monthName = DateFormat.MMMM('es_ES').format(DateTime(_year, month));
    final first = DateTime(_year, month, 1);
    final daysInMonth = DateTime(_year, month + 1, 0).day;
    final offset = first.weekday - 1;

    final cells = List<Widget>.generate(offset, (_) => const SizedBox());
    cells.addAll(
      List.generate(daysInMonth, (i) {
        final day = i + 1;
        final date = DateTime(_year, month, day);
        final key = _toDateKey(date);
        return _dayCell(day: day, promedio: _byDate[key]);
      }),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E88E5), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            _capitalize(monthName),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263238),
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekName('LUN'),
              _WeekName('MAR'),
              _WeekName('MIE'),
              _WeekName('JUE'),
              _WeekName('VIE'),
              _WeekName('SAB'),
              _WeekName('DOM'),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: cells,
          ),
        ],
      ),
    );
  }

  Widget _dayCell({required int day, required num? promedio}) {
    final hasData = promedio != null;
    final asset = hasData ? _assetFromPromedio(promedio) : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD6DDE3)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: Text(
              '$day',
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
          Center(
            child: hasData
                ? ClipOval(
                    child: Image.asset(
                      asset!,
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.emoji_emotions,
                        color: Color(0xFF4FC3F7),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String _assetFromPromedio(num promedio) {
    if (promedio >= 3.6) return 'assets/images/statesuperexcellent.png';
    if (promedio >= 2.8) return 'assets/images/goodrest.jpg';
    if (promedio >= 2.0) return 'assets/images/normalrest.jpg';
    if (promedio >= 1.2) return 'assets/images/yellowrest.jpg';
    return 'assets/images/sadrest.jpg';
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
    return _toDateKey(parsed.add(Duration(days: days)));
  }

  String? _normalizeDateKey(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return null;

    final parsed = DateTime.tryParse(clean);
    if (parsed != null) {
      final local = parsed.isUtc ? parsed.toLocal() : parsed;
      return _toDateKey(DateTime(local.year, local.month, local.day));
    }

    if (clean.length < 10) return null;
    final iso = clean.substring(0, 10);
    final dateOnly = DateTime.tryParse(iso);
    if (dateOnly == null) return null;
    return _toDateKey(dateOnly);
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}

class _WeekName extends StatelessWidget {
  const _WeekName(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFF455A64),
      ),
    );
  }
}
