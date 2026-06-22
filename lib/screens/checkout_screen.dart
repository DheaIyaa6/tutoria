import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🔥 Mengambil UID Student aktif

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> mentor;
  final Function(Map<String, dynamic>)? onBooking;

  const CheckoutScreen({
    super.key,
    required this.mentor,
    this.onBooking,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = false;

  // Fungsi untuk memformat mata uang secara manual (aman tanpa int.parse yang menyebabkan crash)
  String _formatCurrency(dynamic value) {
    if (value == null) return "Rp 0";
    String digits = value.toString().replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return "Rp 0";
    
    final chars = digits.split('');
    String result = '';
    int count = 0;
    
    for (int i = chars.length - 1; i >= 0; i--) {
      result = chars[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }

  // 🔥 CORE LOGIC FIXED: Proses transaksi aman dengan pencatatan Relasi Student & Mentor secara akurat
  Future<void> _processBooking() async {
    setState(() {
      _isLoading = true;
    });

    // 1. Ambil user Student yang sedang login saat ini
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar("Gagal memproses: Sesi login Anda berakhir.", Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    final String scheduleId = widget.mentor['schedule_id'] ?? '';
    if (scheduleId.isEmpty) {
      _showSnackBar("Gagal memproses: ID Jadwal tidak valid.", Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    try {
      // 2. Ambil data profil Student secara real-time dari collection 'users'
      DocumentSnapshot studentProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!studentProfile.exists) {
        throw Exception("Profil data siswa Anda tidak ditemukan.");
      }

      Map<String, dynamic> studentData = studentProfile.data() as Map<String, dynamic>;
      String studentName = studentData['full_name'] ?? 'Siswa Tutoria';
      String studentClass = (studentData['school_class'] ?? '-').toString();
      String studentSchool = studentData['school_level'] ?? '-';

      // 3. Ekstrak data Mentor secara aman dengan pengecekan key ganda (full_name / name)
      String mName = widget.mentor['full_name'] ?? widget.mentor['name'] ?? widget.mentor['mentor_name'] ?? 'Nama Mentor';
      String mMajor = widget.mentor['major'] ?? widget.mentor['faculty'] ?? '-';
      String mCampus = widget.mentor['campus'] ?? '-';
      String mImage = widget.mentor['image'] ?? widget.mentor['mentor_image'] ?? '';

      final DocumentReference scheduleRef =
          FirebaseFirestore.instance.collection('schedules').doc(scheduleId);

      // 4. Menggunakan Firestore Transaction untuk validasi atomic
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(scheduleRef);

        if (!snapshot.exists) {
          throw Exception("Jadwal ini sudah tidak tersedia.");
        }

        Map<String, dynamic> scheduleData = snapshot.data() as Map<String, dynamic>;
        String currentStatus = scheduleData['status'] ?? 'available';

        if (currentStatus != 'available') {
          throw Exception("Maaf, jadwal ini baru saja di-booking oleh orang lain!");
        }

        // 🔥 FIX UTAMA 1: Tulis data identitas student DAN pastikan identitas mentor tertulis lengkap di 'schedules'
        transaction.update(scheduleRef, {
          'status': 'booked',
          'student_id': currentUser.uid,
          'student_name': studentName,
          'student_class': studentClass,
          'student_school': studentSchool,
          'full_name': mName,
          'major': mMajor,
          'campus': mCampus,
          'image': mImage,
        });

        // 🔥 FIX UTAMA 2: Buat dokumen riwayat transaksi baru di collection 'bookings'
        DocumentReference bookingRef =
            FirebaseFirestore.instance.collection('bookings').doc();
            
        transaction.set(bookingRef, {
          'booking_id': bookingRef.id,
          'schedule_id': scheduleId,
          'student_id': currentUser.uid, 
          'student_name': studentName,
          'mentor_id': widget.mentor['mentor_id'] ?? '',
          'mentor_name': mName,
          'mentor_major': mMajor,
          'mentor_campus': mCampus,
          'mentor_image': mImage,
          'day': widget.mentor['day'],
          'time': widget.mentor['time'],
          'price': widget.mentor['price'],
          'created_at': FieldValue.serverTimestamp(),
          'payment_status': 'success',
        });
      });

      _showSnackBar("Booking Berhasil Dikonfirmasi!", Colors.green);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      _showSnackBar(errorMessage, Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Penyelarasan tampilan lokal
    String displayMentorName = widget.mentor['full_name'] ?? widget.mentor['name'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Detail Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- RINGKASAN JADWAL MENTOR ---
                const Text("Ringkasan Mentor & Jadwal", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.mentor["image"] != null && widget.mentor["image"].toString().startsWith("http")
                            ? Image.network(widget.mentor["image"], width: 60, height: 60, fit: BoxFit.cover)
                            : const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayMentorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text("${widget.mentor['major'] ?? '-'} | ${widget.mentor['campus'] ?? '-'}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.deepPurple),
                                const SizedBox(width: 4),
                                Text(widget.mentor["day"] ?? "-", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                const Icon(Icons.access_time_rounded, size: 12, color: Colors.deepPurple),
                                const SizedBox(width: 4),
                                Text(widget.mentor["time"] ?? "-", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // --- RINCIAN BIAYA ---
                const Text("Rincian Biaya", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Biaya Sesi Privat", style: TextStyle(color: Color(0xFF64748B))),
                          Text(_formatCurrency(widget.mentor["price"]), style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Biaya Layanan/Aplikasi", style: TextStyle(color: Color(0xFF64748B))),
                          Text("Rp 0 (FREE)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFF1F5F9)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(
                            _formatCurrency(widget.mentor["price"]),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A237E)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- WARNING INFORMASI ---
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: Colors.orange, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Jadwal yang sudah di-booking tidak dapat dibatalkan secara sepihak tanpa persetujuan mentor.",
                          style: TextStyle(color: Color(0xFFE65100), fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // --- LOADING INDICATOR OVERLAY ---
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)),
              ),
            )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          onPressed: _isLoading ? null : _processBooking,
          child: const Text(
            "Konfirmasi & Bayar Sekarang",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}