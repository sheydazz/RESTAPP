import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'features/intro_auth/screens/how_you_found_screen.dart';
import 'features/intro_auth/screens/intro_screen.dart';
import 'features/intro_auth/screens/login_screen.dart';
import 'features/intro_auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/emotion/screens/emotionregister_screen.dart';
import 'features/emotion/screens/chat_screen.dart';
import 'features/emotion/screens/traffic_light_screen.dart';
import 'features/emotion/screens/advice_screen.dart';
import 'features/emotion/screens/check_screen.dart';
import 'features/progress/screens/progress_screen.dart';
import 'features/navigation/main_app.dart';
import 'features/progress/screens/globalprogress_screen.dart';
import 'features/progress/screens/myprogress_screen.dart';
import 'features/progress/screens/mi_diario_screen.dart';
import 'features/progress/screens/mis_capitulos_screen.dart';
import 'features/progress/screens/capitulo_detalle_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.intro,
      routes: {
        // Intro & Auth
        AppRoutes.intro: (context) =>  IntroScreen(),
        AppRoutes.login: (context) =>  LoginScreen(),
        AppRoutes.register: (context) =>  RegisterScreen(),
        AppRoutes.howYouFound: (context) =>  HowYouFoundScreen(),

        // Main App
        AppRoutes.mainApp: (context) =>  MainApp(),

        // Home
        AppRoutes.home: (context) =>  HomeScreen(),
        AppRoutes.settings: (context) =>  SettingsScreen(),

        // Registro Emocional
        AppRoutes.emotionHome: (context) =>  EmotionRegisterScreen(),
        AppRoutes.chat: (context) =>  ChatScreen(),
        AppRoutes.trafficLight: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return TrafficLightScreen(
            estado: args["estado"],
            mensaje: args["mensaje"],
            botonTexto: args["botonTexto"],
          );
        },

        AppRoutes.advice: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return AdviceScreen(
            userName: args?["userName"] ?? "Usuario",
            adviceTitle: args?["adviceTitle"] ?? "Consejo",
            message: args?["message"] ?? "consejo personalizado.",
          );
        },
        AppRoutes.check: (context) =>  CheckScreen(),

        // Mi Progreso
        AppRoutes.globalprogress: (context) =>  GlobalProgressScreen(),
        AppRoutes.progress: (context) =>  MyProgressScreen(),
        AppRoutes.progress: (context) =>  ProgressScreen(),
        AppRoutes.miDiario: (context) => const MiDiarioScreen(),
        AppRoutes.misCapitulos: (context) => const MisCapitulosScreen(),

        AppRoutes.capituloDetalle: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return CapituloDetalleScreen(
            titulo: args?['titulo'],
            descripcion: args?['descripcion'],
            fecha: args?['fecha'],
          );
        },
      },
    );
  }
}
