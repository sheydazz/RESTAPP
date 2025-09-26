import 'package:flutter/material.dart';
import '../../home/screens/gradient_text.dart';

class FailReportScreen extends StatefulWidget {
  @override
  _FailReportScreenState createState() => _FailReportScreenState();
}

class _FailReportScreenState extends State<FailReportScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
            'Reportar Falla',
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
              // Header con icono
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
                        Icons.bug_report,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reportar falla técnica',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Déjanos saber qué problemas has presentado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Campo de título
              _buildInputField(
                controller: _titleController,
                hintText: 'Título',
                maxLines: 1,
              ),

              const SizedBox(height: 20),

              // Campo de descripción
              _buildInputField(
                controller: _descriptionController,
                hintText: 'Describe con detalles el error que has tenido',
                maxLines: 8,
                isDescription: true,
              ),

              const SizedBox(height: 40),

              // Botón de enviar
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
                      _sendReport();
                    },
                    child: const Center(
                      child: Text(
                        'Enviar Reporte',
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
    bool isDescription = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E7FF).withOpacity(0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textAlignVertical: isDescription ? TextAlignVertical.top : TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        style: TextStyle(
          color: Color(0xFF2E3A59),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _sendReport() {
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos');
      return;
    }

    // Aquí puedes agregar la lógica para enviar el reporte
    // Por ejemplo, enviar a un servidor o guardar localmente

    _showSuccessDialog();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Color(0xFF2E3A59),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '¡Reporte enviado!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          content: Text(
            'Tu reporte ha sido enviado exitosamente. Nos pondremos en contacto contigo pronto.',
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