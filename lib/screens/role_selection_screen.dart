import 'package:flutter/material.dart';
import 'package:tutoria/screens/signup_screen.dart';
import 'package:tutoria/screens/mentor_signup_screen.dart'; // Import halaman baru mentor

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset(
              'assets/images/abstrakpojoklogin.png',
              width: 220,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bottomlogin.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // TOMBOL BACK
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
                  
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/gambar1.png',
                    height: 220,
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Pilih Peran Anda",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sesuaikan akun dengan kebutuhan belajar atau mengajar Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  
                  const Spacer(),
                  
                  // BUTTON DAFTAR JADI STUDENT
                  _buildRoleButton(
                    context, 
                    "Daftar sebagai Student", 
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(selectedRole: 'student'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // BUTTON DAFTAR JADI MENTOR - SEKARANG DIREKAN KE MENTOR SIGNUP SCREEN 🚀
                  _buildRoleButton(
                    context, 
                    "Daftar sebagai Mentor", 
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MentorSignupScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 70),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Fungsi pembangun tombol bersih dengan fungsi aksi dinamis (VoidCallback)
  Widget _buildRoleButton(BuildContext context, String text, VoidCallback onTapAksi) {
    return GestureDetector(
      onTap: onTapAksi,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}