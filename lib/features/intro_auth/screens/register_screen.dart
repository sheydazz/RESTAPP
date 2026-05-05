import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'how_you_found_screen.dart';
import 'package:rest/core/services/auth_service.dart';
import 'package:rest/core/services/user_session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  // Variables para dropdowns
  String? _edadSeleccionada;
  String? _ciudadSeleccionada;
  String? _carreraSeleccionada;
  String? _semestresSeleccionado;
  String? _sexoSeleccionado;

  // Control de visibilidad de contraseña
  bool _isPasswordVisible = false;

  final _authService = AuthService();
  bool _isLoading = false;

  // Listas para los dropdowns
  final List<String> _edades = List.generate(56, (i) => (i + 15).toString());
  final List<String> _ciudades = [
    'Barranquilla',
    'Bogotá',
    'Cali',
    'Cartagena',
    'Medellín',
    'Santa Marta',
    'Valledupar',
    'Bucaramanga',
    'Cúcuta',
    'Ibagué',
    'Manizales',
    'Pereira',
    'Armenia',
    'Popayán',
    'Pasto',
    'Túquerres',
    'Quibdó',
    'Montería',
    'Sincelejo',
    'Riohacha',
    'Santa Fe de Antioquia',
    'Envigado',
    'Sabaneta',
    'La Estrella',
    'Bello',
    'Copacabana',
    'Girardota',
    'Barbosa',
  ];
  final List<String> _carreras = [
    // 🎓 PREGRADOS
    // ⚖️ Derecho y ciencias sociales
    'Derecho',
    'Ciencia Política',
    'Trabajo Social',
    'Comunicación Social y Periodismo',
    // 💰 Ciencias económicas, administrativas y contables
    'Administración de Empresas',
    'Contaduría Pública',
    'Economía',
    'Negocios Internacionales',
    'Mercadeo',
    'Administración de Negocios',
    // 🏥 Ciencias de la salud
    'Medicina',
    'Enfermería',
    'Bacteriología',
    'Instrumentación Quirúrgica',
    'Fisioterapia',
    // ⚙️ Ingeniería y tecnología
    'Ingeniería Industrial',
    'Ingeniería de Sistemas',
    'Ingeniería Civil',
    'Ingeniería Ambiental',
    'Ingeniería Mecánica',
    'Ingeniería en Ciencia de Datos',
    // 🧪 Ciencias básicas
    'Microbiología',
    'Biología',
    // 📚 Educación
    'Licenciatura en Español e Inglés',

    // 📌 ESPECIALIZACIONES
    // ⚖️ Derecho
    'Esp. Derecho Administrativo',
    'Esp. Derecho Constitucional',
    'Esp. Derecho Penal',
    'Esp. Derecho Procesal',
    'Esp. Derecho Laboral',
    'Esp. Derecho Comercial',
    'Esp. Derecho Tributario',
    'Esp. Derecho Médico',
    'Esp. Derecho de Familia',
    // 💼 Administración / negocios
    'Esp. Alta Gerencia',
    'Esp. Gerencia de Proyectos',
    'Esp. Gerencia Tributaria',
    'Esp. Gerencia Financiera',
    'Esp. Gerencia del Talento Humano',
    'Esp. Gerencia de Mercadeo',
    // 🏥 Salud
    'Esp. Gerencia de Servicios de Salud',
    'Esp. Seguridad y Salud en el Trabajo',
    'Esp. Medicina Interna',
    'Esp. Pediatría',
    'Esp. Cirugía General',
    'Esp. Dermatología',
    // ⚙️ Ingeniería
    'Esp. Gerencia Ambiental',
    'Esp. Gestión de la Calidad',
    'Esp. Seguridad Industrial',

    // 🎓 MAESTRÍAS
    // ⚖️ Derecho
    'Maestría en Derecho',
    'Maestría en Derecho Administrativo',
    'Maestría en Derecho Penal',
    'Maestría en Derecho Procesal',
    // 💼 Administración / economía
    'MBA (Administración de Empresas)',
    'Maestría en Administración',
    'Maestría en Gestión de Proyectos',
    'Maestría en Finanzas',
    'Maestría en Economía',
    // 🏥 Salud
    'Maestría en Seguridad y Salud en el Trabajo',
    // 📚 Educación
    'Maestría en Educación',

    // 🏆 DOCTORADOS
    'Doctorado en Derecho',
    'Doctorado en Derecho Administrativo',
    'Doctorado en Filosofía del Derecho y Teoría Jurídica',
  ];
  final List<String> _semestres = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '1 y 2',
    '2 y 3',
    '3 y 4',
    '4 y 5',
    '5 y 6',
    '6 y 7',
    '7 y 8',
    '8 y 9',
    '9 y 10',
  ];
  final List<String> _sexos = [
    'Femenino',
    'Masculino',
    'Otro',
    'Prefiero no decir',
  ];

  static const Map<String, String> _sexoCodes = {
    'Masculino': 'M',
    'Femenino': 'F',
    'Otro': 'O',
    'Prefiero no decir': 'N',
  };

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String? _mapSexoToCode(String? sexoLabel) {
    if (sexoLabel == null || sexoLabel.isEmpty) return null;
    return _sexoCodes[sexoLabel];
  }

  Future<void> _handleRegister() async {
    final nombres = _nombreController.text.trim();
    final apellidos = _apellidoController.text.trim();
    final correo = _correoController.text.trim();
    final contrasena = _passwordController.text.trim();
    final ciudad = _ciudadSeleccionada;
    final telefono = _telefonoController.text.trim();
    final edad = int.tryParse(_edadSeleccionada ?? '');
    final semestreActual = _semestresSeleccionado;
    final sexo = _mapSexoToCode(_sexoSeleccionado);
    final fechaNacimiento = _fechaNacimientoController.text.trim();

    if (nombres.isEmpty ||
        apellidos.isEmpty ||
        correo.isEmpty ||
        contrasena.isEmpty ||
        ciudad == null ||
        ciudad.isEmpty ||
        telefono.isEmpty ||
        edad == null ||
        _carreraSeleccionada == null ||
        _carreraSeleccionada!.isEmpty ||
        semestreActual == null ||
        semestreActual.isEmpty ||
        sexo == null ||
        sexo.isEmpty ||
        fechaNacimiento.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios')),
      );
      return;
    }

    final birthDateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!birthDateRegExp.hasMatch(fechaNacimiento)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha de nacimiento debe tener formato YYYY-MM-DD'),
        ),
      );
      return;
    }

    // Validar formato de correo
    final emailRegExp = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    if (!emailRegExp.hasMatch(correo)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingresa un correo válido')));
      return;
    }

    // Validar longitud de contraseña (> 8 caracteres)
    if (contrasena.length <= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener más de 8 caracteres'),
        ),
      );
      return;
    }

    // Validar teléfono: solo dígitos y más de 6
    final phoneRegExp = RegExp(r'^\d+$');
    if (!phoneRegExp.hasMatch(telefono) || telefono.length <= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El teléfono debe tener solo números y más de 6 dígitos',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.register(
        correo: correo,
        contrasena: contrasena,
        nombres: nombres,
        apellidos: apellidos,
        telefono: telefono,
        ciudad: ciudad,
        edad: edad,
        semestreActual: semestreActual,
        sexo: sexo,
        fechaNacimiento: fechaNacimiento,
      );

      UserSession.currentUserName = nombres;

      // Guardar token y userId directamente del registro (el del login viene mal)
      final dynamic token =
          response['token'] ??
          response['accessToken'] ??
          response['jwt'] ??
          (response['data'] is Map ? (response['data'] as Map)['token'] : null);
      if (token is String && token.isNotEmpty) {
        UserSession.authToken = token;
      }

      final dynamic user =
          response['user'] ??
          (response['data'] is Map ? (response['data'] as Map)['user'] : null);
      if (user is Map && user['id'] is int) {
        UserSession.userId = user['id'] as int;
      } else if (response['id'] is int) {
        UserSession.userId = response['id'] as int;
      }

      // IMPORTANTE: Resetear lastTestDate para cada nuevo usuario
      // Esto garantiza que TODOS los usuarios nuevos vean el test
      UserSession.lastTestDate = null;

      // DEBUG: Descomentar solo en desarrollo
      // print(
      //   'REGISTER SESSION → token=${UserSession.authToken != null ? 'SET' : 'NULL'}, userId=${UserSession.userId}',
      // );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HowYouFoundScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Imagen + Título en una fila
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/normalrest.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0419FF), Color(0xFF0AF3FF)],
                      ).createShader(bounds),
                      child: Text(
                        '¡Háblame de ti!',
                        style: GoogleFonts.fredoka(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              _buildInputField(
                controller: _nombreController,
                label: '¿Cómo quieres que te llame?',
                hint: 'Tu nombre',
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: '¿Cuántos años tienes?',
                hint: 'Selecciona tu edad',
                value: _edadSeleccionada,
                items: _edades,
                onChanged: (value) {
                  setState(() {
                    _edadSeleccionada = value;
                  });
                },
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: '¿De qué ciudad eres?',
                hint: 'Selecciona tu ciudad',
                value: _ciudadSeleccionada,
                items: _ciudades,
                onChanged: (value) {
                  setState(() {
                    _ciudadSeleccionada = value;
                  });
                },
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: '¿Cuál es tu carrera?',
                hint: 'Selecciona tu carrera',
                value: _carreraSeleccionada,
                items: _carreras,
                onChanged: (value) {
                  setState(() {
                    _carreraSeleccionada = value;
                  });
                },
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: '¿Qué semestres cursas?',
                hint: 'Selecciona el semestre',
                value: _semestresSeleccionado,
                items: _semestres,
                onChanged: (value) {
                  setState(() {
                    _semestresSeleccionado = value;
                  });
                },
                isRequired: true,
              ),

              const SizedBox(height: 20),
              _buildDropdownField(
                label: '¿Con qué sexo te identificas?',
                hint: 'Selecciona una opción',
                value: _sexoSeleccionado,
                items: _sexos,
                onChanged: (value) {
                  setState(() {
                    _sexoSeleccionado = value;
                  });
                },
                isRequired: true,
              ),

              const SizedBox(height: 20),
              _buildDateField(
                controller: _fechaNacimientoController,
                label: 'Fecha de nacimiento',
                hint: 'YYYY-MM-DD',
                isRequired: true,
                onTap: () async {
                  final now = DateTime.now();
                  final initialDate = DateTime(
                    now.year - 18,
                    now.month,
                    now.day,
                  );
                  final firstDate = DateTime(1900, 1, 1);
                  final lastDate = now;
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _fechaNacimientoController.text = _formatDate(pickedDate);
                    });
                  }
                },
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: _telefonoController,
                label: 'Teléfono',
                hint: '3001234567',
                isRequired: true,
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: _apellidoController,
                label: 'Apellidos',
                hint: 'Tus apellidos',
                isRequired: true,
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: _correoController,
                label: 'Correo institucional',
                hint: 'example@correo.com',
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _passwordController,
                label: 'Contraseña',
                hint: '••••••••',
                obscure: true,
                isRequired: true,
              ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: _buildRadialButton(
                    text: _isLoading ? 'GUARDANDO...' : 'GUARDAR',
                    onPressed: _isLoading ? null : () => _handleRegister(),
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
    required String label,
    required String hint,
    bool obscure = false,
    bool isRequired = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' Obligatorio',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF6B7A),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFADD8E6), Color(0xFF3A5AFF), Color(0xFF8C4EFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure && !_isPasswordVisible,
              style: GoogleFonts.fredoka(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.fredoka(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Check dinámico (solo si hay texto)
                    if (controller.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3709EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    // Toggle de contraseña (solo si es obscure)
                    if (obscure)
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF3709EC),
                            size: 22,
                          ),
                        ),
                      ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' Obligatorio',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF6B7A),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFADD8E6), Color(0xFF3A5AFF), Color(0xFF8C4EFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          hint,
                          style: GoogleFonts.fredoka(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: value,
                        items: items
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.fredoka(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: onChanged,
                        style: GoogleFonts.fredoka(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Check dinámico (solo si hay selección)
                if (value != null && value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3709EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required VoidCallback onTap,
    bool isRequired = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' Obligatorio',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF6B7A),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFADD8E6), Color(0xFF3A5AFF), Color(0xFF8C4EFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: onTap,
              style: GoogleFonts.fredoka(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.fredoka(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3709EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF3709EC),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadialButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    final gradient = const RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [Color(0xFF5CCFC0), Color(0xFF2981C1)],
    );

    return Container(
      height: 65,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
    );
  }
}
