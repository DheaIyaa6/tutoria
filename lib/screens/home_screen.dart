import 'package:flutter/material.dart';
import 'mentor_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onBooking;
  const HomeScreen({super.key, required this.onBooking});

  @override
  Widget build(BuildContext context) {
    // DATA MENTOR LENGKAP - 12 Mentor (Format Flat/Horizontal per baris)
    final List<Map<String, dynamic>> mentors = [
      {"name": "Alya Putri", "campus": "UI", "major": "Informatika", "price": 50000, "image": "https://randomuser.me/api/portraits/women/1.jpg", "subjects": ["Flutter", "Dart", "UI/UX"], "experience": "3 Tahun Mobile Developer"},
      {"name": "Rizky Pratama", "campus": "ITS", "major": "Teknik Informatika", "price": 60000, "image": "https://randomuser.me/api/portraits/men/2.jpg", "subjects": ["Java", "Spring Boot", "SQL"], "experience": "2 Tahun Backend Engineer"},
      {"name": "Nadia Safira", "campus": "UGM", "major": "Manajemen", "price": 45000, "image": "https://randomuser.me/api/portraits/women/3.jpg", "subjects": ["Marketing", "Business Plan"], "experience": "4 Tahun Business Consultant"},
      {"name": "Fajar Hidayat", "campus": "UNAIR", "major": "Kedokteran", "price": 70000, "image": "https://randomuser.me/api/portraits/men/4.jpg", "subjects": ["Anatomi", "Biologi"], "experience": "1 Tahun Dokter Muda"},
      {"name": "Dinda Laras", "campus": "UNESA", "major": "Pendidikan Matematika", "price": 40000, "image": "https://randomuser.me/api/portraits/women/5.jpg", "subjects": ["Aljabar", "Kalkulus"], "experience": "2 Tahun Pengajar Olimpiade"},
      {"name": "Bima Shakti", "campus": "ITB", "major": "Teknik Elektro", "price": 65000, "image": "https://randomuser.me/api/portraits/men/6.jpg", "subjects": ["Robotika", "IoT"], "experience": "3 Tahun Embedded Engineer"},
      {"name": "Siti Aminah", "campus": "UPI", "major": "Pendidikan B. Inggris", "price": 35000, "image": "https://randomuser.me/api/portraits/women/7.jpg", "subjects": ["TOEFL", "IELTS"], "experience": "2 Tahun English Tutor"},
      {"name": "Andi Wijaya", "campus": "UB", "major": "Ilmu Hukum", "price": 55000, "image": "https://randomuser.me/api/portraits/men/8.jpg", "subjects": ["Hukum Pidana", "Perdata"], "experience": "2 Tahun Junior Lawyer"},
      {"name": "Maya Indah", "campus": "UNDIP", "major": "Psikologi", "price": 48000, "image": "https://randomuser.me/api/portraits/women/9.jpg", "subjects": ["Konseling", "Psikologi Anak"], "experience": "3 Tahun Konselor Sekolah"},
      {"name": "Kevin Sanjaya", "campus": "BINUS", "major": "Game Development", "price": 75000, "image": "https://randomuser.me/api/portraits/men/10.jpg", "subjects": ["Unity", "C#"], "experience": "2 Tahun Game Designer"},
      {"name": "Lusi Natalia", "campus": "UNPAD", "major": "Ilmu Komunikasi", "price": 42000, "image": "https://randomuser.me/api/portraits/women/11.jpg", "subjects": ["Public Speaking", "PR"], "experience": "4 Tahun PR Specialist"},
      {"name": "Reza Rahadian", "campus": "IKJ", "major": "Seni Peran", "price": 90000, "image": "https://randomuser.me/api/portraits/men/12.jpg", "subjects": ["Akting", "Teater"], "experience": "10 Tahun Profesional Aktor"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
  physics: const AlwaysScrollableScrollPhysics(),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  child: Column(
    // ... sisa kode desain kamu jangan disentuh ...
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/Tutoria.png', 
                    height: 45, 
                    errorBuilder: (context, error, stackTrace) => const Text(
                      "TUTORIA", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Color(0xFF1A237E))
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.notifications_none_rounded, size: 28, color: Color(0xFF1A237E)),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- SECTION 2: GREETING ---
              const Text(
                "Halo, Mau Belajar Apa?",
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const Text(
                "Temukan Mentormu",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 20),

              // --- SECTION 3: SEARCH BAR ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari mata pelajaran atau mentor...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF1A237E)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- SECTION 4: HERO BANNER ---
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/laptop.jpg'), 
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                        child: const Text("PROMO KHUSUS", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Dapatkan Diskon 50%\nUntuk Booking Pertama!",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- SECTION 5: TITLE LIST ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recommended Mentor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  TextButton(onPressed: () {}, child: const Text("Lihat Semua", style: TextStyle(color: Colors.blue))),
                ],
              ),
              const SizedBox(height: 10),

              // --- SECTION 6: MENTOR LIST ---
              Column(
                children: mentors.map((m) => _buildMentorCard(context, m)).toList(),
              ),

              // --- BOTTOM SPACING ---
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: MENTOR CARD ---
  Widget _buildMentorCard(BuildContext context, Map<String, dynamic> mentor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1), width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(mentor["image"]),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mentor["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E))),
                    const SizedBox(height: 2),
                    Text("${mentor["major"]} • ${mentor["campus"]}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        const Text("4.9 (120 Ulasan)", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const Spacer(),
                        Text(
                          "Rp ${mentor["price"]}",
                          style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF1A237E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MentorDetailScreen(mentor: mentor)));
                  },
                  child: const Text("Lihat Detail", style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => onBooking(mentor),
                  child: const Text("Booking Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}