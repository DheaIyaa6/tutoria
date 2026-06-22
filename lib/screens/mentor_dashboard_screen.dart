import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutoria/screens/login_screen.dart';
import 'package:tutoria/screens/mentor_schedule_screen.dart'; 
import 'package:tutoria/screens/student_list_screen.dart';

class MentorDashboardScreen extends StatefulWidget {
  const MentorDashboardScreen({super.key});

  @override
  State<MentorDashboardScreen> createState() => _MentorDashboardScreenState();
}

class _MentorDashboardScreenState extends State<MentorDashboardScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? mentorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMentorData();
  }

  Future<void> _loadMentorData() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        
        if (doc.exists) {
          setState(() {
            mentorData = doc.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          "Mentor Dashboard", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER PROFILE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24, top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 50, color: Colors.deepPurple.shade300),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          mentorData?['full_name'] ?? 'Mentor Tutoria',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "STATUS: APPROVED",
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DETAIL RINGKASAN AKADEMIK MENTOR
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "KUALIFIKASI ANDA", 
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildInfoCard(
                          icon: Icons.school, 
                          title: "Kampus", 
                          value: mentorData?['campus'] ?? '-',
                        ),
                        _buildInfoCard(
                          icon: Icons.auto_stories, 
                          title: "Bidang Ajar Utama", 
                          value: mentorData?['teaching_subject'] ?? '-',
                          iconColor: Colors.orange,
                        ),
                        _buildInfoCard(
                          icon: Icons.polyline, 
                          title: "Fakultas & Jurusan", 
                          value: "${mentorData?['faculty'] ?? '-'} (${mentorData?['major'] ?? '-'})",
                          iconColor: Colors.green,
                        ),
                        _buildInfoCard(
                          icon: Icons.location_on, 
                          title: "Kecamatan Mengajar", 
                          value: "Kec. ${mentorData?['district'] ?? '-'}",
                          iconColor: Colors.red,
                        ),

                        const SizedBox(height: 30),
                        
                        const Text(
                          "MENU MENTOR", 
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            _buildMenuButton(
                              icon: Icons.calendar_month, 
                              label: "Jadwal\nMengajar", 
                              color: Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const MentorScheduleScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildMenuButton(
                              icon: Icons.group, 
                              label: "Daftar\nSiswa", 
                              color: Colors.purple,
                              onTap: () {
                                // 🔥 KODE SUDAH AKTIF: Navigasi real-time langsung ke halaman daftar siswa
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const StudentListScreen()),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  // WIDGET CARD INFORMASI
  Widget _buildInfoCard({
    required IconData icon, 
    required String title, 
    required String value, 
    Color iconColor = Colors.deepPurple,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // WIDGET TOMBOL MENU
  Widget _buildMenuButton({
    required IconData icon, 
    required String label, 
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 4))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            highlightColor: color.withOpacity(0.05),
            splashColor: color.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}