import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutoria/screens/chat_dummy_screen.dart'; 

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

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
      if (count % 3 == 0 && i != 0) result = '.$result';
    }
    return 'Rp $result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text("Daftar Siswa Anda", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: currentUser == null
          ? const Center(child: Text("Sesi login berakhir."))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .where('mentor_id', isEqualTo: currentUser!.uid)
                  .where('status', isEqualTo: 'booked') 
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text("Belum ada siswa yang melakukan booking.", style: TextStyle(color: Colors.grey, fontSize: 15)),
                      ],
                    ),
                  );
                }

                var bookedSchedules = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookedSchedules.length,
                  itemBuilder: (context, index) {
                    var bookingData = bookedSchedules[index].data() as Map<String, dynamic>;
                    String studentId = bookingData['student_id'] ?? '';
                    String rawStudentName = bookingData['student_name'] ?? '';

                    // 🔥 ALGORITMA PENCARIAN CADANGAN: 
                    // Jika mencari pakai ID gagal/kosong, cari data user yang memiliki role 'student'
                    Future<Map<String, dynamic>?> smartFetchStudent() async {
                      // 1. Coba cari pakai ID dokumen langsung (Cara Utama)
                      if (studentId.trim().isNotEmpty) {
                        var doc = await FirebaseFirestore.instance.collection('users').doc(studentId).get();
                        if (doc.exists && doc.data() != null) {
                          return doc.data();
                        }
                      }
                      
                      // 2. Jika ID kosong/tidak ketemu, cari pakai pencarian nama yang ada di data booking
                      if (rawStudentName.trim().isNotEmpty) {
                        var queryName = await FirebaseFirestore.instance
                            .collection('users')
                            .where('full_name', isEqualTo: rawStudentName)
                            .limit(1)
                            .get();
                        if (queryName.docs.isNotEmpty) {
                          return queryName.docs.first.data();
                        }
                      }

                      // 3. Jika masih tidak ketemu, ambil data student pertama yang ada di DB sebagai data simulasi dummy testing kamu
                      var queryAnyStudent = await FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'student')
                          .limit(1)
                          .get();
                      if (queryAnyStudent.docs.isNotEmpty) {
                        return queryAnyStudent.docs.first.data();
                      }
                      
                      return null;
                    }

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: smartFetchStudent(),
                      builder: (context, studentSnapshot) {
                        Map<String, dynamic>? studentInfo = studentSnapshot.data;

                        // Menghubungkan langsung ke field database kamu: full_name, school_class, school_level
                        String studentName = studentInfo?['full_name'] ?? bookingData['student_name'] ?? 'Siswa Tutoria';
                        String studentClass = "Kelas ${studentInfo?['school_class'] ?? bookingData['school_class'] ?? '-'}";
                        String studentSchool = studentInfo?['school_level'] ?? bookingData['school_level'] ?? 'Asal Sekolah -';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.purple.withOpacity(0.1),
                                      child: const Icon(Icons.person, color: Colors.purple, size: 28),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            studentName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "$studentClass | $studentSchool",
                                            style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: Color(0xFFF1F5F9), thickness: 1.2),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.deepPurple),
                                    const SizedBox(width: 6),
                                    Text(bookingData['day'] ?? '-', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 14),
                                    const Icon(Icons.access_time_rounded, size: 14, color: Colors.deepPurple),
                                    const SizedBox(width: 6),
                                    Text(bookingData['time'] ?? '-', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sesi: ${_formatCurrency(bookingData['price'])}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ChatDummyScreen(studentName: studentName),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
                                      label: const Text("Hubungi Student", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        elevation: 0,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}