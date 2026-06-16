import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDetailListScreen extends StatelessWidget {
  final String viewType; 

  const AdminDetailListScreen({super.key, required this.viewType});

  String _getAppBarTitle() {
    switch (viewType) {
      case 'student': return "Manajemen Data Student";
      case 'mentor_active': return "Manajemen Mentor Aktif";
      case 'mentor_pending': return "Persetujuan Berkas Mentor";
      case 'bookings': return "History Transaksi Booking";
      default: return "Detail Halaman";
    }
  }

  Future<void> _toggleUserBlockStatus(BuildContext context, String uid, String currentStatus) async {
    String nextStatus = currentStatus == 'blocked' ? 'approved' : 'blocked';
    String pesan = currentStatus == 'blocked' ? "Blokir akun berhasil dibuka!" : "Akun berhasil diblokir!";
    
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'status': nextStatus});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan), backgroundColor: const Color(0xFF0F172A)));
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengupdate status: $e")));
    }
  }

  Future<void> _respondToMentorApplication(BuildContext context, String uid, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'status': status});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == 'approved' ? "Pendaftaran Mentor Diterima!" : "Pendaftaran Mentor Ditolak!"),
            backgroundColor: status == 'approved' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('users');
    
    if (viewType == 'student') {
      query = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'student');
    } else if (viewType == 'mentor_active') {
      query = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'mentor').where('status', whereIn: ['approved', 'blocked']);
    } else if (viewType == 'mentor_pending') {
      query = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'mentor').where('status', isEqualTo: 'pending');
    } else if (viewType == 'bookings') {
      query = FirebaseFirestore.instance.collection('bookings'); 
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0F172A)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Tidak ada data transaksi atau user yang tercatat saat ini.", style: TextStyle(color: Colors.grey)),
            );
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String docId = docs[index].id;

              if (viewType == 'bookings') {
                String status = data['status'] ?? 'pending';
                Color statusColor = Colors.orange;
                if (status == 'success' || status == 'completed') statusColor = Colors.green;
                if (status == 'cancelled' || status == 'cancel') statusColor = Colors.red;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12), // FIX: Menggunakan EdgeInsets.only(bottom: 12) resmi Flutter
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(backgroundColor: statusColor.withOpacity(0.1), child: Icon(Icons.payment, color: statusColor)),
                    title: Text("Sesi: ${data['subject'] ?? 'Mata Pelajaran'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Student: ${data['student_name'] ?? '-'}  |  Mentor: ${data['mentor_name'] ?? '-'}"),
                        Text("Tanggal: ${data['date'] ?? '-'} (${data['time'] ?? '-'})", style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                      child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }

              String statusUser = data['status'] ?? 'approved';
              bool isBlocked = statusUser == 'blocked';

              return Card(
                margin: const EdgeInsets.only(bottom: 14), // FIX: Menggunakan EdgeInsets.only(bottom: 14) resmi Flutter
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: isBlocked ? Colors.red.shade50 : Colors.blue.shade50,
                    child: Icon(Icons.person, color: isBlocked ? Colors.red : const Color(0xFF3B82F6)),
                  ),
                  title: Row(
                    children: [
                      Text(data['full_name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      if (isBlocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                          child: const Text("BLOCKED", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                  subtitle: Text(
                    viewType == 'student' ? (data['email'] ?? '-') : "${data['major'] ?? '-'} — ${data['campus'] ?? '-'}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          Text("📧 Email Kontak: ${data['email'] ?? '-'}"),
                          if (data['phone'] != null) Text("📞 No. WhatsApp: ${data['phone']}"),
                          if (data['faculty'] != null) Text("🎓 Fakultas & Jurusan: ${data['faculty']} (${data['major']})"),
                          if (data['teaching_subject'] != null) Text("📚 Fokus Bidang Ajar: ${data['teaching_subject']}"),
                          if (data['district'] != null) Text("📍 Wilayah Tugas: Kec. ${data['district']}"),
                          if (data['reason'] != null) ...[
                            const SizedBox(height: 8),
                            Text("📝 Motivasi Gabung: \"${data['reason']}\"", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87)),
                          ],
                          const SizedBox(height: 14),

                          if (viewType == 'mentor_pending') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _respondToMentorApplication(context, docId, 'rejected'),
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                                  child: const Text("TOLAK PENDAFTAR"),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => _respondToMentorApplication(context, docId, 'approved'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                  child: const Text("TERIMA MENTOR"),
                                ),
                              ],
                            )
                          ] else ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _toggleUserBlockStatus(context, docId, statusUser),
                                icon: Icon(isBlocked ? Icons.lock_open : Icons.block, size: 16),
                                label: Text(isBlocked ? "BUKA BLOKIR AKUN PENGGUNA" : "BLOKIR AKSES AKUN SEKARANG"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isBlocked ? Colors.green.shade700 : Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}