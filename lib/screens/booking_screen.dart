import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'chat_screen.dart';

class BookingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> bookedData; // Tetap dipertahankan agar parameter konstruktor lama tidak error
  final VoidCallback? onBack;

  const BookingScreen({
    super.key,
    required this.bookedData,
    this.onBack,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Ambil user student yang saat ini sedang login aktif
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      appBar: AppBar(
        title: const Text(
          "Jadwal Booking Anda",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
        ),
      ),
      body: currentUser == null
          ? const Center(child: Text("Sesi login berakhir."))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .where('student_id', isEqualTo: currentUser!.uid) // Hanya jadwal milik student ini
                  // 🔥 FIX UTAMA: Filter status dibuang dari query agar status 'Completed' & 'Cancelled' tetap ikut ditarik ke aplikasi
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                var schedulesDocs = snapshot.data!.docs;

                return _buildBookingList(schedulesDocs);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_turned_in_rounded,
              size: 48,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Belum Ada Sesi Dibooking",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Selesaikan pembayaran sesi mentormu terlebih dahulu dan riwayatnya akan muncul di sini.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        var docId = docs[index].id;
        final booking = docs[index].data() as Map<String, dynamic>;
        
        // 🔥 PENYELARASAN STATUS DI FLUTTER:
        // Jika status bernilai 'booked', maka itu artinya status aslinya sedang "Ongoing"
        String rawStatus = booking["status"] ?? "booked";
        final String status = rawStatus == "booked" ? "Ongoing" : rawStatus;

        Color statusColor = const Color(0xFF059669); 
        Color statusBg = const Color(0xFFECFDF5);
        if (status == "Ongoing") {
          statusColor = const Color(0xFFD97706); 
          statusBg = const Color(0xFFFFFBEB);
        } else if (status == "Cancelled") {
          statusColor = const Color(0xFFDC2626); 
          statusBg = const Color(0xFFFEF2F2);
        }

        String mentorName = booking["full_name"] ?? booking["mentor_name"] ?? booking["name"] ?? "Nama Mentor";
        String mentorMajor = booking["major"] ?? booking["faculty"] ?? booking["mentor_major"] ?? "-";
        String mentorCampus = booking["campus"] ?? booking["mentor_campus"] ?? "-";
        String mentorImage = booking["image"] ?? booking["mentor_image"] ?? "";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFEFF6FF),
                    backgroundImage: mentorImage.isNotEmpty && mentorImage.toString().startsWith("http")
                        ? NetworkImage(mentorImage)
                        : null,
                    child: mentorImage.isNotEmpty && mentorImage.toString().startsWith("http")
                        ? null
                        : const Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentorName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "$mentorMajor • $mentorCampus",
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: Color(0xFFF1F5F9)),
              ),

              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFF475569)),
                  const SizedBox(width: 6),
                  Text(
                    booking["day"] ?? booking["date"] ?? "-",
                    style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time_filled_rounded, size: 16, color: Color(0xFF475569)),
                  const SizedBox(width: 6),
                  Text(
                    booking["time"] ?? "-",
                    style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              // 🔥 Bagian Tombol Aksi: Hanya muncul jika statusnya masih Ongoing ('booked')
              if (status == "Ongoing") ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(mentorName: mentorName),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                          label: const Text("Hubungi", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('schedules')
                                .doc(docId)
                                .update({'status': 'Completed'}); // Mengubah status menjadi Completed di Firestore
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF059669),
                            side: const BorderSide(color: Color(0xFF059669)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Selesai", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 38,
                      width: 42,
                      child: OutlinedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('schedules')
                              .doc(docId)
                              .update({'status': 'Cancelled'}); // Mengubah status menjadi Cancelled di Firestore
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          side: const BorderSide(color: Color(0xFFFCA5A5)),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Icon(Icons.delete_outline_rounded, size: 18),
                      ),
                    ),
                  ],
                )
              ]
            ],
          ),
        );
      },
    );
  }
}