// main.dart
import 'package:flutter/material.dart';
import 'package:tutoria/screens/splash_screen.dart'; // <--- Pastikan import ini ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutoria',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
      ),
      home: const AwalanPage(title: 'Flutter Demo Home Page'),
      // GANTI BAGIAN INI:
      home: const SplashScreen(), // Kembalikan ke SplashScreen kamu yang lama
    );
  }
}
