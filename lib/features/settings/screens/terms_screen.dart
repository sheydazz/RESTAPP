import 'package:flutter/material.dart';
import '../../home/screens/gradient_text.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
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
            'Términos',
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
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0AF3FF), Color(0xFF0419FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Términos y condiciones',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Contenido de términos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermSection(
                      '1. Objeto del servicio',
                      'La aplicación tiene como finalidad brindar herramientas de apoyo emocional, seguimiento del bienestar mental, orientación general y recursos informativos mediante inteligencia artificial.',
                    ),

                    _buildTermSection(
                      '2. Naturaleza del servicio',
                      'La aplicación no presta servicios médicos, psicológicos clínicos ni psiquiátricos. La información proporcionada no constituye diagnóstico, tratamiento ni reemplaza la atención profesional especializada.',
                    ),

                    _buildTermSection(
                      '3. Registro y acceso',
                      'Para utilizar determinadas funciones, el usuario podrá crear una cuenta proporcionando información veraz, actualizada y completa. El usuario es responsable de la seguridad de sus credenciales de acceso.',
                    ),

                    _buildTermSection(
                      '4. Uso adecuado de la plataforma',
                      'El usuario se compromete a utilizar la aplicación de manera lícita, ética y responsable, absteniéndose de realizar actividades que afecten el funcionamiento del sistema o perjudiquen a terceros.',
                    ),

                    _buildTermSection(
                      '5. Privacidad y tratamiento de datos',
                      'Los datos personales suministrados serán tratados conforme a la Política de Privacidad de la aplicación y la normativa vigente de protección de datos personales.',
                    ),

                    _buildTermSection(
                      '6. Inteligencia artificial',
                      'Las respuestas generadas por inteligencia artificial son automáticas, orientativas y pueden presentar limitaciones o errores. Se recomienda validar información sensible con profesionales competentes.',
                    ),

                    _buildTermSection(
                      '7. Situaciones de emergencia',
                      'La aplicación no sustituye servicios de emergencia. En casos de crisis emocional, riesgo suicida o peligro inmediato, el usuario deberá acudir a líneas de atención, servicios médicos o autoridades competentes.',
                    ),

                    _buildTermSection(
                      '8. Propiedad intelectual',
                      'El diseño, contenido, software, logotipos y funcionalidades de la aplicación son propiedad de sus desarrolladores o titulares autorizados y están protegidos por la legislación aplicable.',
                    ),

                    _buildTermSection(
                      '9. Suspensión de uso',
                      'La administración podrá suspender o restringir el acceso a usuarios que incumplan estos términos o hagan uso indebido de la plataforma.',
                    ),

                    _buildTermSection(
                      '10. Modificaciones',
                      'Los presentes términos podrán ser actualizados en cualquier momento. Las modificaciones serán notificadas dentro de la aplicación.',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Botón de aceptación (opcional)
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0AF3FF), Color(0xFF0419FF)],
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
                      _showAcceptanceDialog(context);
                    },
                    child: const Center(
                      child: Text(
                        'He leído y acepto',
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermSection(String title, String content, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        if (!isLast) const SizedBox(height: 20),
      ],
    );
  }

  void _showAcceptanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '¡Términos aceptados!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          content: Text(
            'Has aceptado los términos y condiciones de uso de la aplicación.',
            style: TextStyle(
              color: Color(0xFF2E3A59),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Volver a configuración
              },
              child: Text(
                'Entendido',
                style: TextStyle(
                  color: Color(0xFF4FC3F7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}