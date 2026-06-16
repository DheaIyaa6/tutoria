import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Wajib tambahkan import ini paling atas!
import 'screens/splash_screen.dart';

void main() async {
  // 2. Wajib tambahkan 2 baris ini agar Firebase-mu inisialisasi duluan sebelum aplikasi jalan
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp()); // 3. Pastikan "MyApp()" ini sesuai dengan nama class utama aplikasimu ya!
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
      home: const SplashScreen(), // Kembalikan ke SplashScreen kamu yang lama
    );
  }
}
