import 'package:flutter/material.dart';
import 'mentor_detail_screen.dart';
import 'checkout_screen.dart';
import 'notification_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'voucher_screen.dart';
import 'favorite_mentor_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onBooking;

  const HomeScreen({
    super.key,
    this.onBooking, 
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  String selectedCategory = ""; 

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> banners = [
      {
        "title": "Diskon 50% Booking Pertama",
        "sub": "Mulai belajar intensif bersama mentor pilihan.",
        "image": "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600", 
        "route": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VoucherScreen()));
        }
      },
      {
        "title": "Cek Mentor Favoritmu",
        "sub": "Simpan pengajar terbaikmu agar tidak ketinggalan kelas.",
        "image": "https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=600",
        "route": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoriteMentorScreen()));
        }
      }
    ];

    final List<Map<String, dynamic>> categories = [
      {"name": "Tech", "icon": Icons.code_rounded, "color": const Color(0xFFE8EAF6)},
      {"name": "Business", "icon": Icons.trending_up_rounded, "color": const Color(0xFFE8F5E9)},
      {"name": "Medical", "icon": Icons.health_and_safety_rounded, "color": const Color(0xFFFCE4EC)},
      {"name": "Language", "icon": Icons.translate_rounded, "color": const Color(0xFFFFF3E0)},
      {"name": "Law", "icon": Icons.gavel_rounded, "color": const Color(0xFFEFEBE9)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/Tutoria.png',
                    height: 40,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      "TUTORIA",
                      style: TextStyle(
                        fontWeight: FontWeight.w900, 
                        fontSize: 24,
                        color: Color(0xFF1A237E),
                        letterSpacing: 0.5
                      )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 24,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              const Text(
                "Halo, Mau Belajar Apa?",
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              const Text(
                "Jadwal Privat Mentor",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 20),

              // --- SECTION 2: SEARCH BAR ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Cari mata pelajaran, nama mentor, atau kampus...",
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- SECTION 3: KATEGORI ---
              const Text(
                "Kategori Populer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 95,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedCategory == cat["name"].toLowerCase();
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = isSelected ? "" : cat["name"].toLowerCase();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF1A237E) : cat["color"],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                cat["icon"],
                                color: isSelected ? Colors.white : const Color(0xFF1A237E),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat["name"],
                              style: TextStyle(
                                fontSize: 12, 
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: const Color(0xFF1E293B)
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // --- SECTION 4: BANNER SLIDER ---
              CarouselSlider(
                options: CarouselOptions(
                  height: 160,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                ),
                items: banners.map((banner) {
                  return GestureDetector(
                    onTap: () => banner["route"](),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.network(
                            banner["image"],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF42A5F5),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: const Text(
                                    "PROMO SPESIAL",
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  banner["title"],
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner["sub"],
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // --- SECTION 5: REAL TIME JADWAL ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Jadwal Mengajar Aktif",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  if (selectedCategory.isNotEmpty || searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = "";
                          searchQuery = "";
                          searchController.clear();
                        });
                      },
                      child: const Text("Reset", style: TextStyle(color: Colors.red)),
                    )
                ],
              ),
              const SizedBox(height: 14),

              // 🔥 STREAMBUILDER FIX: Memfilter real-time jadwal yang berstatus 'available' saja
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schedules')
                    .where('status', isEqualTo: 'available') // 👈 Mengunci agar yang booked langsung hilang otomatis
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 40),
                        child: Text("Belum ada jadwal mengajar aktif saat ini.", style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  var rawSchedules = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rawSchedules.length,
                    itemBuilder: (context, index) {
                      var scheduleData = rawSchedules[index].data() as Map<String, dynamic>;
                      String mentorId = scheduleData['mentor_id'] ?? '';

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(mentorId).get(),
                        builder: (context, mentorSnapshot) {
                          if (mentorSnapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink(); 
                          }

                          if (!mentorSnapshot.hasData || !mentorSnapshot.data!.exists) {
                            return const SizedBox.shrink(); 
                          }

                          var mentorData = mentorSnapshot.data!.data() as Map<String, dynamic>;

                          // MAPPING DATA GABUNGAN AMAN
                          Map<String, dynamic> combinedData = {
                            "name": mentorData["full_name"] ?? "Nama Tidak Ditemukan",
                            "major": mentorData["major"] ?? "-",
                            "campus": mentorData["campus"] ?? "-",
                            "image": mentorData["image"] ?? "",
                            "category": mentorData["category"] ?? "",
                            "experience": mentorData["cv_link"] ?? "-",
                            "faculty": mentorData["faculty"] ?? "-",
                            "semester": mentorData["semester"] ?? "-",
                            "age": mentorData["age"] ?? "-",
                            "district": mentorData["district"] ?? "-",
                            "email": mentorData["email"] ?? "-",
                            "schedule_id": rawSchedules[index].id,
                            "day": scheduleData["day"] ?? "-",
                            "time": scheduleData["time"] ?? "-",
                            "price": scheduleData["price"] ?? "0",
                          };

                          // --- Validasi Filter Search & Kategori Konten ---
                          String name = combinedData["name"].toString().toLowerCase();
                          String major = combinedData["major"].toString().toLowerCase();
                          String campus = combinedData["campus"].toString().toLowerCase();
                          String category = combinedData["category"].toString().toLowerCase();

                          bool matchesSearch = name.contains(searchQuery) || 
                                               major.contains(searchQuery) || 
                                               campus.contains(searchQuery);
                          bool matchesCategory = selectedCategory.isEmpty || category == selectedCategory;

                          if (!matchesSearch || !matchesCategory) {
                            return const SizedBox.shrink(); 
                          }

                          return _buildScheduleCard(context, combinedData);
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET MODERN SCHEDULE CARD ---
  Widget _buildScheduleCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: data["image"] != null && data["image"].toString().startsWith("http")
                    ? Image.network(
                        data["image"],
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const CircleAvatar(radius: 32, child: Icon(Icons.person)),
                      )
                    : const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFEFF6FF),
                        child: Icon(Icons.person, color: Colors.blue, size: 30),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${data['major']} | ${data['campus']}",
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.deepPurple),
                        const SizedBox(width: 6),
                        Text(
                          data["day"],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time_rounded, size: 14, color: Colors.deepPurple),
                        const SizedBox(width: 6),
                        Text(
                          data["time"],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tarif Privat Sesi Ini", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  Text(
                    "Rp ${data["price"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E)),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => MentorDetailScreen(mentor: data)
                        ),
                      );
                    },
                    child: const Text("Detail Mentor", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 4),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            mentor: data,
                            onBooking: widget.onBooking,
                          ),
                        ),
                      );
                      
                      if (result == true && widget.onBooking != null) {
                        widget.onBooking!(data);
                      }
                    },
                    child: const Text("Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}