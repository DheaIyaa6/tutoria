import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'admin_detail_list_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // 1. WELCOME BANNER UTAMA DENGAN BACKGROUND GAMBAR SISWA.JPG
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  // MENGGUNAKAN SISWA.JPG SEBAGAI LATAR BELAKANG UTAMA
                  image: DecorationImage(
                    image: AssetImage('assets/images/siswa.jpg'),
                    fit: BoxFit.cover,
                    // Memberikan lapisan gelap transparan agar teks putih tetap terbaca kontras
                    colorFilter: ColorFilter.mode(
                      Color(0xE60F172A), // Campuran warna hitam slate gelap (90% opacity)
                      BlendMode.srcOver,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Teratas: Logo Tutoria & Tombol Logout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/Tutoria.png',
                          height: 28, 
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              "TUTORIA",
                              style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.w900, 
                                fontSize: 20, 
                                letterSpacing: 1.5
                              ),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            }
                          },
                          icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 22),
                          tooltip: 'Keluar Sistem',
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    
                    // Teks Selamat Datang Menumpuk Indah di Atas Background Gambar
                    const Text(
                      "Sistem Kendali Utama 👋", 
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(right: 32),
                      child: Text(
                        "Pantau statistik, kelola pengguna, verifikasi berkas, dan lacak transaksi dalam satu halaman scroll.", 
                        style: TextStyle(
                          color: Color(0xFFCBD5E1), // Warna teks abu-abu terang agar seimbang
                          fontSize: 13, 
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. JUDUL MENU & SEPARATOR
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "MENU & STATISTIK SISTEM", 
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.5),
                ),
              ),

              // 3. STREAM DATA DRIVEN DASHBOARD CARDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, userSnapshot) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
                      builder: (context, bookingSnapshot) {
                        
                        int totalStudents = 0;
                        int totalMentors = 0;
                        int pendingMentors = 0;
                        int totalBookings = 0;

                        if (userSnapshot.hasData) {
                          for (var doc in userSnapshot.data!.docs) {
                            var data = doc.data() as Map<String, dynamic>;
                            String role = data['role'] ?? '';
                            String status = data['status'] ?? '';

                            if (role == 'student') totalStudents++;
                            if (role == 'mentor' && status == 'approved') totalMentors++;
                            if (role == 'mentor' && status == 'pending') pendingMentors++;
                          }
                        }

                        if (bookingSnapshot.hasData) {
                          totalBookings = bookingSnapshot.data!.docs.length;
                        }

                        return Column(
                          children: [
                            _buildModernCard(
                              context: context,
                              title: "TOTAL STUDENT",
                              count: totalStudents.toString(),
                              subtitle: "Klik untuk melihat daftar & blokir murid",
                              icon: Icons.school_rounded,
                              accentColor: const Color(0xFF3B82F6), 
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminDetailListScreen(viewType: 'student')),
                              ),
                            ),

                            _buildModernCard(
                              context: context,
                              title: "MENTOR DISETUJUI (AKTIF)",
                              count: totalMentors.toString(),
                              subtitle: "Klik untuk manajemen kompetensi & blokir mentor",
                              icon: Icons.verified_user_rounded,
                              accentColor: const Color(0xFF10B981), 
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminDetailListScreen(viewType: 'mentor_active')),
                              ),
                            ),

                            _buildModernCard(
                              context: context,
                              title: "PENGAJUAN MENTOR BARU",
                              count: pendingMentors.toString(),
                              subtitle: "Klik untuk periksa berkas, Approve atau Tolak",
                              icon: Icons.assignment_ind_rounded,
                              accentColor: const Color(0xFFF59E0B), 
                              badgeCount: pendingMentors, 
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminDetailListScreen(viewType: 'mentor_pending')),
                              ),
                            ),

                            _buildModernCard(
                              context: context,
                              title: "HISTORY BOOKING & TRANSAKSI",
                              count: totalBookings.toString(),
                              subtitle: "Klik untuk memantau status Sukses / Cancel les",
                              icon: Icons.history_toggle_off_rounded,
                              accentColor: const Color(0xFF6366F1), 
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminDetailListScreen(viewType: 'bookings')),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET CARD MODERN
  Widget _buildModernCard({
    required BuildContext context,
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03), 
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          highlightColor: accentColor.withOpacity(0.02),
          splashColor: accentColor.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
                const SizedBox(width: 18),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            count, 
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.1),
                          ),
                          if (badgeCount > 0) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444), 
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "TINDAKAN", 
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                              ),
                            )
                          ]
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle, 
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1), size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}