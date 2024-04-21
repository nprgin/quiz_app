import 'package:flutter/material.dart';
import 'package:quizz_app/screens/loading_screen.dart';
import '/screens/home_screen.dart';
import '/screens/settings_screen.dart';
import 'package:quizz_app/screens/play_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/loading',
      routes: {
        '/': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/play': (context) => const PlayScreen(),
      },
    );
  }
}