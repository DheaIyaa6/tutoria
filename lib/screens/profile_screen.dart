import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Container(
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
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            const Text(
              "Dimas Anggara",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const Text(
              "Mahasiswa Sistem Informasi • UI",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // --- MENU LIST SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileMenu(Icons.person_outline_rounded, "Personal Information"),
                  _buildProfileMenu(Icons.history_rounded, "Learning History"),
                  _buildProfileMenu(Icons.payment_rounded, "Payment Methods"),
                  _buildProfileMenu(Icons.settings_outlined, "Settings"),
                  const Divider(height: 40, thickness: 1),
                  _buildProfileMenu(Icons.help_outline_rounded, "Help Center"),
                  _buildProfileMenu(Icons.logout_rounded, "Sign Out", isLogout: true),
                ],
              ),
            ),
            const SizedBox(height: 100), // Spacing buat navbar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, {bool isLogout = false}) {
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
        leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF1A237E)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}