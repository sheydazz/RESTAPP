import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Boton primario con degradado, shimmer opcional y trailing opcional.
/// Reemplaza los botones _buildIngresarButton/_buildUnirmeButton que estaban
/// duplicados dentro de login_screen. El shimmer ya no usa un offset fijo en
/// pixeles (antes: `_shimmer.value * 300`, que no calzaba con el ancho real
/// del boton en pantallas angostas/anchas); ahora se calcula con el ancho
/// real via LayoutBuilder.
///
/// Es puramente visual: la interaccion (tap, estado "pressed") la maneja
/// el GestureDetector del widget padre, que es quien conoce la logica de
/// negocio (login, navegacion, etc.).
class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.pressed = false,
    this.shimmerValue,
    this.widthFraction,
    this.trailing,
    this.gradientColors = const [Color(0xFF5CCFC0), Color(0xFF2981C1)],
    this.height = 60,
    this.fontSize = 24,
  });

  final String label;
  final bool isLoading;
  final bool pressed;
  final double? shimmerValue;
  final double? widthFraction;
  final Widget? trailing;
  final List<Color> gradientColors;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final width = widthFraction != null
        ? MediaQuery.of(context).size.width * widthFraction!
        : double.infinity;

    return AnimatedScale(
      scale: pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: SizedBox(
        width: width,
        height: height.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                if (shimmerValue != null)
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Transform.translate(
                        offset: Offset(shimmerValue! * constraints.maxWidth, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.18),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize.sp,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            if (trailing != null) ...[
                              SizedBox(width: 8.w),
                              trailing!,
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
