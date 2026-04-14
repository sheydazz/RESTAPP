import 'dart:math';
import 'package:flutter/material.dart';

class StarRainWidget extends StatefulWidget {
  final int starCount;
  final Duration duration;

  const StarRainWidget({
    Key? key,
    this.starCount = 30,
    this.duration = const Duration(seconds: 6),
  }) : super(key: key);

  @override
  State<StarRainWidget> createState() => _StarRainWidgetState();
}

class _StarRainWidgetState extends State<StarRainWidget>
    with TickerProviderStateMixin {
  late List<_StarData> _stars;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initializeStars();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  void _initializeStars() {
    final random = Random();
    _stars = List.generate(widget.starCount, (index) {
      return _StarData(
        x: random.nextDouble(),
        size: random.nextDouble() * 18 + 14,
        opacity: random.nextDouble() * 0.7 + 0.3,
        delay: random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          return Stack(
            children: List.generate(_stars.length, (index) {
              final star = _stars[index];
              final t = (_controller.value + star.delay) % 1.0;
              final y = (t * 1.25 - 0.2) * height;

              double opacity = star.opacity;
              if (t < 0.12) opacity *= t / 0.12;
              if (t > 0.88) opacity *= (1.0 - t) / 0.12;

              return Positioned(
                left: star.x * (width - star.size),
                top: y,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Image.asset(
                    'assets/images/star.png',
                    width: star.size,
                    height: star.size,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _StarData {
  final double x;
  final double size;
  final double opacity;
  final double delay;

  _StarData({
    required this.x,
    required this.size,
    required this.opacity,
    required this.delay,
  });
}
