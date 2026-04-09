import 'package:flutter/material.dart';
import 'package:rest/core/routes/app_routes.dart';
import 'package:rest/core/services/user_session.dart';
import '../utils/emotion_state_config.dart';

class AdviceScreen extends StatelessWidget {
  final String userName;
  final String adviceTitle;
  final String message;
  final double? promedioHoy;
  final String estado; // Nuevo parámetro de estado

  const AdviceScreen({
    Key? key,
    required this.userName,
    required this.adviceTitle,
    required this.message,
    this.promedioHoy,
    this.estado = 'normal',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = EmotionStateConfig.getConfig(estado);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: config.colorPrincipal,
        elevation: 0,
        title: const Text(
          'Cuidado Personal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de encabezado con cara y saludo
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      config.colorPrincipal.withOpacity(0.15),
                      config.colorSecundario.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: config.colorPrincipal.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    // Cara del usuario con emoji
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: config.colorPrincipal,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: config.colorPrincipal.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          config.imagenAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.sentiment_satisfied,
                            size: 50,
                            color: config.colorPrincipal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Saludo y mensaje de bienvenida
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, ${UserSession.displayName}!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: config.colorPrincipal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Aquí encontrarás recomendaciones',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Título de sección
              Text(
                config.titulo,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: config.colorPrincipal,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              // Mensaje contextual
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: config.colorPrincipal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: config.colorPrincipal.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.mensaje,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: config.colorTexto,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      config.mensaje2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: config.colorTexto.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sección de Recomendaciones
              Text(
                '💡 Recomendaciones para ti:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 16),

              // Lista de recomendaciones
              ...config.recomendaciones.map((rec) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: config.colorPrincipal.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      rec,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 32),

              // Sección de recursos según el estado
              if (estado == 'preocupante' || estado == 'critico') ...[
                Text(
                  '🆘 Recursos de Ayuda:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResourceItem('PAS Colombia', '123', Colors.red),
                      const SizedBox(height: 10),
                      _buildResourceItem(
                        'Línea de Emergencia Mental',
                        '+57 1 2288019',
                        Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      _buildResourceItem(
                        'Chat con Psicólogo (24h)',
                        'Disponible en la app',
                        Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Botón de acción
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.colorPrincipal,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    shadowColor: config.colorPrincipal.withOpacity(0.4),
                  ),
                  onPressed: () {
                    // Después de leer consejos, ir al registro guardado
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.check,
                      arguments: {'promedioHoy': promedioHoy},
                    );
                  },
                  child: const Text(
                    'Ver Registro Guardado →',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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

  Widget _buildResourceItem(String title, String contact, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.phone, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  contact,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
