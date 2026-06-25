import 'package:flutter/material.dart';

class NoaVideoWeb extends StatelessWidget {
  final double width;
  final double height;

  const NoaVideoWeb({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/NoaBase.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
