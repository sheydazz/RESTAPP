import 'package:flutter/material.dart';



class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontWeight: FontWeight.w600,
            fontSize: 20,
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
              _buildConfigItem('Perfil', Icons.person_outline, () {}),
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
                    onTap: () {},
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: hasSwitch ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF4FC3F7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                ),
                if (hasSwitch)
                  Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: const Color(0xFF4FC3F7),
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF9E9E9E),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}