import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart'; 
import 'role_selection_screen.dart'; 
import 'main_screen.dart'; 
import 'admin_dashboard_screen.dart'; 
import 'mentor_dashboard_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final FirebaseService _firebaseService = FirebaseService();
  bool obscure = true;

  Future<void> prosesLogin() async {
    if (_formKey.currentState!.validate()) {
      // Menampilkan Dialog Loading Utama
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        DocumentSnapshot userDoc = await _firebaseService.loginUser(
          email: emailController.text.trim(), // Tambahkan .trim() agar menghindari spasi tidak sengaja
          password: passwordController.text,
        );

        // PENTING: Tutup dialog loading segera setelah data Firestore berhasil ditarik
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (userDoc.exists) {
          String fullName = userDoc.get('full_name') ?? 'User';
          String role = userDoc.get('role') ?? 'student';

          if (mounted) {
            // 1. GERBANG LOGIN ADMIN
            if (role == 'admin') {
              _showWelcomeSnackBar(fullName);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
              );
            } 
            // 2. GERBANG LOGIN MENTOR
            else if (role == 'mentor') {
              String status = userDoc.get('status') ?? 'pending';
              
              if (status != 'approved') {
                // Beri pesan edukatif jika status di database tidak persis bernilai 'approved'
                _showErrorSnackBar("Akun Mentor Anda masih dalam proses verifikasi Admin atau dinonaktifkan.");
                await FirebaseAuth.instance.signOut(); 
              } else {
                _showWelcomeSnackBar(fullName);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MentorDashboardScreen()),
                );
              }
            } 
            // 3. GERBANG LOGIN STUDENT
            else {
              _showWelcomeSnackBar(fullName);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            }
          }
        } else {
          if (mounted) _showErrorSnackBar("Data pengguna tidak ditemukan di database.");
        }
      } on FirebaseAuthException catch (e) {
        // Tutup loading jika terjadi error otentikasi Firebase
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        
        String pesanError = "Terjadi kesalahan";
        if (e.code == 'user-not-found') {
          pesanError = 'Email belum terdaftar.';
        } else if (e.code == 'wrong-password') {
          pesanError = 'Password yang Anda masukkan salah.';
        } else if (e.code == 'invalid-email') {
          pesanError = 'Format email tidak valid.';
        } else {
          pesanError = e.message ?? pesanError;
        }
        if (mounted) _showErrorSnackBar("Gagal: $pesanError");
      } catch (e) {
        // Tutup loading jika terjadi error parsing data / sistem global
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        if (mounted) _showErrorSnackBar("Error: $e");
      }
    }
  }

  void _showWelcomeSnackBar(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Selamat Datang, $name!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration customInput(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF4F7FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: IgnorePointer(
              child: Image.asset('assets/images/abstrakpojoklogin.png', width: 200),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset('assets/images/bottomlogin.png', width: double.infinity, fit: BoxFit.fitWidth),
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/images/backlogin.png', width: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/Tutoria.png', height: 60),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          validator: (value) => value!.isEmpty ? "Email tidak boleh kosong" : null,
                          decoration: customInput("Email"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscure,
                          validator: (value) => value!.isEmpty ? "Password tidak boleh kosong" : null,
                          decoration: customInput("Password").copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => obscure = !obscure),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: prosesLogin,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          "LOG IN",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}