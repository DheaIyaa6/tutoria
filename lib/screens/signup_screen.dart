import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart'; // 1. Panggil file service yang baru
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  final String? selectedRole; 

  const SignupScreen({super.key, this.selectedRole});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // KONTROLLER UNTUK MENANGKAP INPUTAN USER
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = TextEditingController();
  final classController = TextEditingController();

  // 2. Inisialisasi instance dari FirebaseService
  final FirebaseService _firebaseService = FirebaseService();

  bool obscure = true;

  // FUNGSI UI UNTUK MENANGANI TOMBOL DAFTAR
  Future<void> prosesSignup() async {
    if (_formKey.currentState!.validate()) {
      // Tampilkan Loading Dialog (Tugas UI)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // 3. Panggil fungsi registrasi murni dari service
        await _firebaseService.registerUser(
          email: emailController.text,
          password: passwordController.text,
          fullName: nameController.text,
          role: widget.selectedRole ?? "student",
          schoolLevel: schoolController.text,
          schoolClass: classController.text,
        );

        if (mounted) Navigator.pop(context); // Tutup loading

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Akun Berhasil Dibuat di Firebase!")),
          );
          
          // Pindah ke halaman Login setelah sukses
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          });
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context); // Tutup loading
        
        // Handle error ramah user (Tugas UI)
        String pesanError = "Terjadi kesalahan";
        if (e.code == 'weak-password') {
          pesanError = 'Password terlalu lemah.';
        } else if (e.code == 'email-already-in-use') {
          pesanError = 'Email ini sudah terdaftar oleh user lain.';
        } else {
          pesanError = e.message ?? pesanError;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal: $pesanError")),
          );
        }
      } catch (e) {
        if (mounted) Navigator.pop(context); // Tutup loading
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      }
    }
  }

  // Desain kolom inputan biar seragam
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
            child: IgnorePointer( 
              child: Image.asset(
                'assets/images/bottomlogin.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          /// CONTENT
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 10),

                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/backlogin.png',
                        width: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOGO
                  Image.asset('assets/images/Tutoria.png', height: 50),

                  const SizedBox(height: 10),

                  /// GAMBAR UTAMA
                  Image.asset('assets/images/signuporang.png', height: 130),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Sign Up sebagai ${widget.selectedRole ?? 'User'}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// CONTAINER FORM GABUNGAN
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
                        /// FULL NAME
                        TextFormField(
                          controller: nameController,
                          validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
                          decoration: customInput("Full Name"),
                        ),
                        const SizedBox(height: 12),

                        /// EMAIL
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) return "Email wajib diisi";
                            if (!value.endsWith("@gmail.com")) return "Harus pakai @gmail.com";
                            return null;
                          },
                          decoration: customInput("Email"),
                        ),
                        const SizedBox(height: 12),

                        /// PASSWORD
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscure,
                          validator: (value) => value!.length < 8 ? "Minimal 8 karakter" : null,
                          decoration: customInput("Password").copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => obscure = !obscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// ASAL SEKOLAH
                        TextFormField(
                          controller: schoolController,
                          validator: (value) => value!.isEmpty ? "Asal sekolah wajib diisi" : null,
                          decoration: customInput("Asal Sekolah"),
                        ),
                        const SizedBox(height: 12),

                        /// KELAS
                        TextFormField(
                          controller: classController,
                          validator: (value) => value!.isEmpty ? "Kelas wajib diisi" : null,
                          decoration: customInput("Kelas"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON SIGN UP
                  GestureDetector(
                    onTap: prosesSignup,
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
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}