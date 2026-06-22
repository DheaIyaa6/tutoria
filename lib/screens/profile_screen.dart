import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'splash_screen.dart';
import 'personal_info_screen.dart';
import 'favorite_mentor_screen.dart';
import 'voucher_screen.dart';
import 'settings_screen.dart';
import 'help_center_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fungsi untuk mengambil data user student dari Firestore berdasarkan UID yang sedang login
  Future<Map<String, dynamic>?> _getStudentData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
          
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A237E);
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: currentUser == null
          ? const Center(child: Text("Sesi login berakhir. Silakan login kembali."))
          : FutureBuilder<Map<String, dynamic>?>(
              future: _getStudentData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                // Ambil data dari snapshot database, gunakan fallback default jika field kosong
                final studentData = snapshot.data;
                final String name = studentData?['name'] ?? studentData?['full_name'] ?? "Nama Student";
                final String studentClass = studentData?['class'] ?? studentData?['kelas'] ?? "Kelas -";
                final String school = studentData?['school'] ?? studentData?['school_name'] ?? studentData?['asal_sekolah'] ?? "Sekolah -";
                final String email = studentData?['email'] ?? currentUser.email ?? "-";
                final String photoUrl = studentData?['image'] ?? studentData?['photoUrl'] ?? "";

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // --- HEADER SECTION ---
                      SizedBox(
                        height: 220,
                        child: Stack(
                          children: [
                            Container(
                              height: 150,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  backgroundImage: photoUrl.isNotEmpty && photoUrl.startsWith("http")
                                      ? NetworkImage(photoUrl)
                                      : null,
                                  child: photoUrl.isNotEmpty && photoUrl.startsWith("http")
                                      ? null
                                      : const Icon(Icons.person, size: 60, color: primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
Text(
  name,
  textAlign: TextAlign.center, //  Sudah diperbaiki
  style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: primaryColor),
),
const SizedBox(height: 4),
Text(
  "$studentClass - $school",
  textAlign: TextAlign.center, //  Sudah diperbaiki
  style: const TextStyle(fontSize: 14, color: Colors.grey),
),
Text(
  email,
  textAlign: TextAlign.center, //  Sudah diperbaiki
  style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
),

                      const SizedBox(height: 25),

                      // --- MENU LIST SECTION ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildProfileMenu(
                              Icons.person_outline_rounded,
                              "Personal Information",
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PersonalInfoScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildProfileMenu(
                              Icons.favorite_border_rounded,
                              "Favorite Mentors",
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FavoriteMentorScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildProfileMenu(
                              Icons.local_offer_outlined,
                              "Promo / Voucher",
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const VoucherScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildProfileMenu(
                              Icons.settings_outlined,
                              "Settings",
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 40, thickness: 1),
                            _buildProfileMenu(
                              Icons.help_outline_rounded,
                              "Help Center",
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HelpCenterScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildProfileMenu(
                              Icons.logout_rounded,
                              "Sign Out",
                              () async {
                                // Logout dari Firebase Auth secara real sebelum dilempar ke Splash Screen
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SplashScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              isLogout: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfileMenu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF1A237E),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}