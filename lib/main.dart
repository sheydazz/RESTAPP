import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'features/intro_auth/screens/intro_screen.dart';
import 'features/intro_auth/screens/login_screen.dart';
import 'features/intro_auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/settings_screen.dart';
import 'features/home/screens/help_screen.dart';
import 'features/emotion/screens/emotionregister_screen.dart';
import 'features/emotion/screens/chat_screen.dart';
import 'features/emotion/screens/traffic_light_screen.dart';
import 'features/emotion/screens/advice_screen.dart';
import 'features/emotion/screens/check_screen.dart';
import 'features/progress/screens/progress_screen.dart';
import 'features/navigation/main_app.dart';

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

        // Main App
        AppRoutes.mainApp: (context) =>  MainApp(),

        // Home
        AppRoutes.home: (context) =>  HomeScreen(),
        AppRoutes.settings: (context) =>  SettingsScreen(),
        AppRoutes.help: (context) =>  HelpScreen(),

        // Registro Emocional
        AppRoutes.emotionHome: (context) =>  EmotionRegisterScreen(),
        AppRoutes.chat: (context) =>  ChatScreen(),
        AppRoutes.trafficLight: (context) => TrafficLightScreen(),
        AppRoutes.advice: (context) =>  AdviceScreen(),
        AppRoutes.check: (context) =>  CheckScreen(),

        // Mi Progreso
        AppRoutes.progress: (context) =>  ProgressScreen(),
      },
    );
  }
}
