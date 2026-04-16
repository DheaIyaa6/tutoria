import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND ATAS
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset(
              'assets/images/abstrakpojoklogin.png',
              width: 200,
            ),
          ),

          /// BACKGROUND BAWAH
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bottomlogin.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          /// CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  /// BACK BUTTON (FIX BERFUNGSI)
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/backlogin.png',
                        width: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOGO
                  Image.asset(
                    'assets/images/Tutoria.png',
                    height: 50,
                  ),

                  const SizedBox(height: 20),

                  /// ILUSTRASI
                  Image.asset(
                    'assets/images/signinorang.png',
                    height: 180,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// FORM
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// EMAIL
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email wajib diisi";
                              }
                              if (!value.endsWith("@gmail.com")) {
                                return "Email harus menggunakan @gmail.com";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              filled: true,
                              fillColor: const Color(0xFFF4F7FB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// PASSWORD
                          TextFormField(
                            obscureText: obscure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password wajib diisi";
                              }
                              if (value.length < 8) {
                                return "Password salah";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              filled: true,
                              fillColor: const Color(0xFFF4F7FB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// INI KUNCINYA (BIAR TOMBOL PAS POSISI)
                  const Spacer(),

                  /// SIGN IN BUTTON
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70), // 🔥 posisi pas
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainScreen()),
                          );
                        }
                      },
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
