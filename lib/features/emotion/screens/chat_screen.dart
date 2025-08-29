import 'package:flutter/material.dart';
import 'package:rest/features/emotion/screens/emotionregister_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [
    ChatMessage(
      text:
      "¡Hola! Soy Noa, me gustaría que me cuentes un poco más sobre ti, ¿cómo te sientes hoy? ¿Cómo te gustaría que me diría que te nombrará?",
      isUser: false,
    ),
    ChatMessage(
      text:
      "¡Hola! Soy Mari, realmente hoy me siento un poco desanimada, las cosas no se han dado bien, el trabajo, la familia....",
      isUser: true,
    ),
    ChatMessage(
      text:
      "Gracias por confiar en mí, Mari. Siento mucho que estás pasando por un momento complicado. A veces todo se junta y puede ser abrumador, pero hablarlo ya es un paso importante.",
      isUser: false,
    ),
    ChatMessage(
      text:
      "¿Te gustaría contarme un poco más sobre lo que te está afectando? Estoy aquí para escucharte sin juzgar",
      isUser: false,
    ),
    ChatMessage(
      text:
      "Sí, la verdad es que últimamente siento que hago todo lo posible, pero nada sale como espero. Me esfuerzo en el trabajo, en casa, pero no veo resultados, y eso me hace sentir agotada y sin ánimos.",
      isUser: true,
    ),
    ChatMessage(
      text:
      "Es completamente válido sentirse así, Mari. Lo que estás viviendo suena realmente difícil, y es normal sentirse cansada cuando sientes que estás dando todo de ti.",
      isUser: false,
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          text: _messageController.text,
          isUser: true,
        ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo a la izquierda y títulos centrados
            Container(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  // Logo en la esquina superior izquierda
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFF7DFDFE),
                            Color(0xFF4ECDC4),
                            Color(0xFF00B4D8),
                          ],
                          stops: [0.0, 0.6, 1.0],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF4ECDC4), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4ECDC4).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Ojos
                          Positioned(
                            top: 22,
                            left: 20,
                            child: _eye(),
                          ),
                          Positioned(
                            top: 22,
                            right: 20,
                            child: _eye(),
                          ),
                          // Sonrisa
                          Positioned(
                            bottom: 18,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          // Mejillas
                          Positioned(
                            top: 35,
                            left: 8,
                            child: _cheek(),
                          ),
                          Positioned(
                            top: 35,
                            right: 8,
                            child: _cheek(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Títulos centrados
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [Color(0xFF7DFDFE), Color(0xFF2196F3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              "¡Hablemos",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Fredoka',
                                height: 0.9,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [Color(0xFF7DFDFE), Color(0xFF2196F3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              "un Rato!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Fredoka',
                                height: 0.9,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chat container con borde redondeado azul
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFF153E75), width: 4), // Azul marino
                ),
                child: Stack(
                  children: [
                    // Lista de mensajes
                    Padding(
                      padding: EdgeInsets.only(
                          top: 60, left: 20, right: 20, bottom: 20),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(message: messages[index]);
                        },
                      ),
                    ),
                    // Botón "Detener"
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmotionRegisterScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pause,
                                  color: Colors.black, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Detener",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Fredoka',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Input area
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6A4C93), // Morado
                            Color(0xFF153E75), // Azul marino
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3), // Grosor del borde degradado
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Comparte tu mensaje aquí..",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Fredoka',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Freeman',
                              fontSize: 16,
                            ),
                            onSubmitted: (value) => _sendMessage(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage, // <-- Hacer funcional el botón de enviar
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xFF3B2C5E), // Azul marino con toque morado
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // Sin relleno
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3), // Solo borde blanco
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white, // Flecha blanca
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eye() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _cheek() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Color(0xFFFF9AA2).withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Color(0xFF64B5F6).withOpacity(0.85) // Usuario: azul claro menos transparente
                    : Color(0xFFB3E5FC), // Receptor: azul más claro
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black, // Texto en negro
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Freeman',
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
