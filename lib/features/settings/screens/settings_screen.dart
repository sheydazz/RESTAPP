import 'package:flutter/material.dart';
import '../../home/screens/gradient_text.dart';
import 'profile_screen.dart'; // Importar la pantalla de perfil

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        titleSpacing: 0, // Reducido para mejor control del espaciado
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70, // Ancho específico para el leading
        leading: Center( // Centra verticalmente el botón
          child: Container(
            margin: const EdgeInsets.only(left: 20), // Margen desde la izquierda
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
          margin: const EdgeInsets.only(left: 10), // Pequeño margen para separar del botón
          child: GradientText(
            'Configuración',
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
              _buildSectionTitle('Cuenta'),
              const SizedBox(height: 15),
              _buildConfigItem('Perfil', Icons.person_outline, () {
                // Navegar a la pantalla de perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              }),
              _buildConfigItem('Plan Actual', Icons.diamond_outlined, () {}),
              _buildConfigItem('Referidos', Icons.group_outlined, () {}),
              _buildConfigItem('Código de regalo', Icons.card_giftcard_outlined, () {}),

              const SizedBox(height: 30),
              _buildSectionTitle('Ajustes'),
              const SizedBox(height: 15),
              _buildConfigItem('Modo oscuro', Icons.dark_mode_outlined, () {}, hasSwitch: true),
              _buildConfigItem('Recordatorios', Icons.notifications_outlined, () {}),
              _buildConfigItem('Pin de seguridad', Icons.lock_outlined, () {}),
              _buildConfigItem('Idioma', Icons.language_outlined, () {}),

              const SizedBox(height: 30),
              _buildSectionTitle('Soporte'),
              const SizedBox(height: 15),
              _buildConfigItem('Reportar falla técnica', Icons.bug_report_outlined, () {}),
              _buildConfigItem('Enviar feedback', Icons.feedback_outlined, () {}),
              _buildConfigItem('Código de conducta', Icons.gavel_outlined, () {}),
              _buildConfigItem('Aviso de privacidad', Icons.privacy_tip_outlined, () {}),
              _buildConfigItem('Términos y condiciones', Icons.description_outlined, () {}),

              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withOpacity(0.3),
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
                      // Aquí puedes agregar lógica para cerrar sesión
                      _showLogoutDialog(context);
                    },
                    child: const Center(
                      child: Text(
                        'CERRAR SESIÓN',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E3A59),
      ),
    );
  }

  Widget _buildConfigItem(String title, IconData icon, VoidCallback onTap, {bool hasSwitch = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasSwitch ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF4FC3F7),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                ),
                if (hasSwitch)
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: const Color(0xFF4FC3F7),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF9E9E9E),
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '¿Cerrar sesión?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(
              color: Color(0xFF2E3A59),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Color(0xFF4FC3F7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí puedes agregar la lógica para cerrar sesión
                // Por ejemplo: navegar a la pantalla de login
              },
              child: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Color(0xFFE91E63),
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