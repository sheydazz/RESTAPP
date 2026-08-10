import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest/core/services/profile_service.dart';

import '../../home/screens/gradient_text.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _profileService.fetchProfile();
      if (!mounted) return;

      setState(() {
        _nombreController.text = profile.nombreCompleto;
        _correoController.text = profile.correo;
        _ciudadController.text = profile.ciudad ?? '';
        _semestreController.text = profile.semestreActual ?? '';
        _telefonoController.text = profile.telefono ?? '';
        _fechaNacimientoController.text = profile.fechaNacimientoFormateada;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _ciudadController.dispose();
    _semestreController.dispose();
    _telefonoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 25),
              ),
            ),
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: GradientText(
            'Perfil',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30.sp),
            gradient: LinearGradient(
              colors: [Color(0xFF0AF3FF), Color(0xFF0419FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 40,
              ),
              SizedBox(height: 12.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _loadProfile,
                child: Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF0AF3FF), Color(0xFF0419FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF0AF3FF).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(Icons.person, color: Colors.white, size: 50),
              ),
            ),
            SizedBox(height: 30.h),
            _buildInputField('Nombre', _nombreController),
            SizedBox(height: 20.h),
            _buildInputField('Correo', _correoController),
            SizedBox(height: 20.h),
            _buildInputField('Ciudad', _ciudadController),
            SizedBox(height: 20.h),
            _buildInputField('Semestre', _semestreController),
            SizedBox(height: 20.h),
            _buildInputField('Teléfono', _telefonoController),
            SizedBox(height: 20.h),
            _buildInputField('Fecha de nacimiento', _fechaNacimientoController),
            SizedBox(height: 40.h),
            Container(
              width: double.infinity,
              height: 55.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0AF3FF), Color(0xFF0419FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0AF3FF).withValues(alpha: 0.3),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Perfil actualizado correctamente'),
                        backgroundColor: Color(0xFF4FC3F7),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'GUARDAR CAMBIOS',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
