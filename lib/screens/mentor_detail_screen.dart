import 'package:flutter/material.dart';

class MentorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> mentor;

  const MentorDetailScreen({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    // Ambil data dengan fallback aman jika nilainya kosong/null
    final String name = mentor["name"] ?? "Nama Tidak Tersedia";
    final String email = mentor["email"] ?? "Email tidak dicantumkan";
    final String campus = mentor["campus"] ?? "-";
    final String major = mentor["major"] ?? "-";
    final String faculty = mentor["faculty"] ?? "-";
    final String semester = mentor["semester"]?.toString() ?? "-";
    final String age = mentor["age"]?.toString() ?? "-";
    final String experience = mentor["experience"] ?? "Belum ada pengalaman hidup/CV yang dibagikan.";
    final String imageUrl = mentor["image"] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Background abu-abu lembut modern
      appBar: AppBar(
        title: const Text(
          "Profil Mentor",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        // FIX: Menggunakan bottom PreferredSize agar tidak error sintaksis lagi
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Color(0xFFE2E8F0),
            height: 1,
            thickness: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: UTAMA (FOTO, NAMA, KAMPUS) ---
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1A237E), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFEFF6FF),
                      backgroundImage: imageUrl.startsWith("http") ? NetworkImage(imageUrl) : null,
                      child: !imageUrl.startsWith("http")
                          ? const Icon(Icons.person, size: 55, color: Color(0xFF1A237E))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E2F1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      campus,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- SECTION 2: INFORMASI AKADEMIK & PRIBADI ---
            const Text(
              "Informasi Detail",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.mail_outline_rounded, "Email", email),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(Icons.school_rounded, "Fakultas", faculty),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(Icons.auto_stories_rounded, "Jurusan", major),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(Icons.timeline_rounded, "Semester", "Semester $semester"),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(Icons.cake_rounded, "Usia", "$age Tahun"),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- SECTION 3: PENGALAMAN HIDUP / BIOGRAFI / CV ---
            const Text(
              "Pengalaman Hidup & Mengajar (CV)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                experience,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          ),
      ],
    );
  }
}