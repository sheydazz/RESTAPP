import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.onTap,
    this.icon,
    this.imagePath,
    this.size = 40,
    this.backgroundColor = const Color(0xFF87CEEB),
    this.iconColor = Colors.white,
  }) : assert(icon != null || imagePath != null);

  final VoidCallback onTap;
  final IconData? icon;
  final String? imagePath;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final scaledSize = size.w;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(scaledSize),
      child: Container(
        width: scaledSize,
        height: scaledSize,
        decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: Center(
          child: icon != null
              ? Icon(icon, color: iconColor, size: (size * 0.55).sp)
              : Padding(
                  padding: EdgeInsets.all(scaledSize * 0.15),
                  child: Image.asset(imagePath!, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}
