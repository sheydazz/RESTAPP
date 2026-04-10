import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rest/core/services/chat_service.dart';
import 'package:rest/features/emotion/screens/chat_screen.dart';
import 'gradient_text.dart';

class ConversacionesScreen extends StatefulWidget {
  const ConversacionesScreen({super.key});

  @override
  State<ConversacionesScreen> createState() => _ConversacionesScreenState();
}

class _ConversacionesScreenState extends State<ConversacionesScreen> {
  final ChatService _chatService = ChatService();

  bool _loading = true;
  String? _error;
  List<ChatSessionSummary> _historial = const [];

  @override
  void initState() {
    super.initState();
    _loadHistorial();
  }

  Future<void> _loadHistorial() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _chatService.fetchHistorialIA();
      if (!mounted) return;
      setState(() {
        _historial = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
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
                child: Icon(Icons.arrow_back, color: Colors.white, size: 25),
              ),
            ),
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: GradientText(
            'Conversaciones',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
            gradient: LinearGradient(
              colors: [Color(0xFF0AF3FF), Color(0xFF0419FF)],
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
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _errorState()
              : _historial.isEmpty
              ? _emptyState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _historial
                      .map(
                        (h) => _buildConversacionItem(h, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(initialChatId: h.chatId),
                            ),
                          );
                        }),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }

  Widget _errorState() {
    return Column(
      children: [
        Text(
          'No se pudo cargar conversaciones',
          style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(_error ?? '', textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _loadHistorial,
          child: const Text('Reintentar'),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return const Column(
      children: [
        Icon(Icons.chat_bubble_outline, size: 72, color: Color(0xFF90A4AE)),
        SizedBox(height: 10),
        Text(
          'Aun no tienes sesiones con NOA',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w700,
            color: Color(0xFF546E7A),
          ),
        ),
      ],
    );
  }

  Widget _buildConversacionItem(ChatSessionSummary item, VoidCallback onTap) {
    final fecha = DateFormat('dd/MM/yyyy HH:mm').format(item.ultimaActividad);
    final titulo = item.isActive
        ? 'Sesion activa con NOA'
        : 'Sesion finalizada';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF08B1DD), width: 2),
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chat_bubble, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$fecha • ${item.totalMensajes} mensajes\n${item.preview}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
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
