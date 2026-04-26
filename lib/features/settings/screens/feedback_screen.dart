import 'package:flutter/material.dart';
import '../../home/screens/gradient_text.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedRating = -1;
  final Set<int> _selectedOptions = {};
  TextEditingController commentController = TextEditingController();

  final List<String> ratingEmojis = ['😠', '🙁', '😐', '🙂', '😍'];

  static const List<String> _positiveOptions = [
    'Las conversaciones con Noa',
    'El registro emocional',
    'Las técnicas de relajación',
    'El seguimiento de actividades',
    'Mi diario personal',
    'El diseño de la app',
  ];

  static const List<String> _negativeOptions = [
    'Las conversaciones con Noa',
    'El registro emocional',
    'Las técnicas de relajación',
    'La velocidad de la app',
    'El diseño de la app',
  ];

  List<String> get _currentOptions =>
      selectedRating != -1 && selectedRating <= 1 ? _negativeOptions : _positiveOptions;

  String get _optionsQuestion =>
      selectedRating != -1 && selectedRating <= 1 ? '¿Qué mejorarías?' : '¿Qué te gustó?';

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leadingWidth: 70,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF08B1DD),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: GradientText(
            'Feedback',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            gradient: LinearGradient(
              colors: [
                Color(0xFF0AF3FF),
                Color(0xFF0419FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comparte tu opinión',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Califica tu experiencia',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Rating emojis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                final wasNegative = selectedRating != -1 && selectedRating <= 1;
                                final willBeNegative = index <= 1;
                                if (wasNegative != willBeNegative) _selectedOptions.clear();
                                selectedRating = index;
                              });
                            },
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: selectedRating == index
                                    ? Color(0xFF4FC3F7).withOpacity(0.1)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: selectedRating == index
                                    ? Border.all(
                                  color: Color(0xFF4FC3F7),
                                  width: 2,
                                )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  ratingEmojis[index],
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      if (selectedRating != -1) ...[
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            selectedRating == 4 ? '¡Excelente!' :
                            selectedRating == 3 ? 'Buena' :
                            selectedRating == 2 ? 'Regular' :
                            selectedRating == 1 ? 'Mala' : 'Muy mala',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4FC3F7),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      Text(
                        _optionsQuestion,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Puedes elegir varias opciones',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Options
                      ...List.generate(_currentOptions.length, (index) {
                        final isSelected = _selectedOptions.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedOptions.remove(index);
                              } else {
                                _selectedOptions.add(index);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF4FC3F7).withOpacity(0.08)
                                  : Theme.of(context).colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4FC3F7)
                                    : Theme.of(context).colorScheme.outlineVariant,
                                width: isSelected ? 1.8 : 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF4FC3F7)
                                          : Theme.of(context).colorScheme.outlineVariant,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFF4FC3F7)
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _currentOptions[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF4FC3F7)
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 25),

                      Text(
                        'Escribe tu comentario (opcional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Comment text field
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: commentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Describe tu experiencia',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Send button
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0AF3FF),
                              Color(0xFF0419FF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0AF3FF).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              _sendFeedback();
                            },
                            child: const Center(
                              child: Text(
                                'Enviar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
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

  void _sendFeedback() {
    if (selectedRating == -1) {
      _showSnackBar('Por favor selecciona una calificación');
      return;
    }
    if (_selectedOptions.isEmpty && commentController.text.trim().isEmpty) {
      _showSnackBar('Selecciona al menos una opción o escribe un comentario');
      return;
    }

    _showSnackBar('¡Gracias por tu feedback!');
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF4FC3F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}