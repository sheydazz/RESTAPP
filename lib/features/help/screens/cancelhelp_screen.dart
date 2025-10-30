import 'package:flutter/material.dart';

import '../../home/screens/home_screen.dart';
import 'help_screen.dart';

class CancelHelpScreen extends StatelessWidget {
  const CancelHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener ancho y alto de la pantalla
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: width * 0.9, // 90% del ancho de pantalla
          height: height * 0.8, // 90% de la altura de pantalla
          padding: EdgeInsets.all(width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen del muñequito
              Image.asset(
                "assets/images/sadbluerest.png",
                width: width * 0.6,   // 40% del ancho
                height: height * 0.4 , // 20% de la altura
              ),

              // Texto principal
              Text(
                "¿Estás Segura?",
                style: TextStyle(
                  fontSize: width * 0.08, // tamaño relativo
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: height * 0.015),

              Text(
                "Vamos Marilis",
                style: TextStyle(
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: height * 0.015),

              Text(
                "¡No está mal buscar ayuda!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: height * 0.02),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón verde
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.01,
                        horizontal: width * 0.02,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text(
                      "Volver a enviar \n la solicitud",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.05),

                  // Botón rojo
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.01,
                        horizontal: width * 0.03,
                      ),
                    ),
                    onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    icon: const Icon(Icons.close, color: Colors.white),

                    label: Text(
                      "No, gracias pero\nno me siento lista",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
