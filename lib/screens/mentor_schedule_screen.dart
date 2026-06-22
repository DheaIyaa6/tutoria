import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentorScheduleScreen extends StatefulWidget {
  const MentorScheduleScreen({super.key});

  @override
  State<MentorScheduleScreen> createState() => _MentorScheduleScreenState();
}

class _MentorScheduleScreenState extends State<MentorScheduleScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  
  final dayController = TextEditingController(); 
  final timeController = TextEditingController();
  final priceController = TextEditingController(); 
  final noteController = TextEditingController(); 

  DateTime? _selectedDate;

  @override
  void dispose() {
    dayController.dispose();
    timeController.dispose();
    priceController.dispose();
    noteController.dispose(); 
    super.dispose();
  }

  Future<void> _tambahJadwal() async {
    if (_formKey.currentState!.validate() && currentUser != null) {
      try {
        await FirebaseFirestore.instance.collection('schedules').add({
          'mentor_id': currentUser!.uid,
          'day': dayController.text.trim(), 
          'time': timeController.text.trim(),
          'price': priceController.text.trim(), 
          'note': noteController.text.trim(), 
          'status': 'available', 
          'created_at': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.pop(context); 
          dayController.clear();
          timeController.clear();
          priceController.clear();
          noteController.clear(); 
          _selectedDate = null; 
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Jadwal dan tarif mengajar berhasil ditambahkan!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menambah jadwal: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showAddScheduleBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tambah Jadwal Mengajar",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: dayController,
                      readOnly: true, 
                      decoration: const InputDecoration(
                        labelText: "Pilih Tanggal Belajar",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(), 
                          lastDate: DateTime(DateTime.now().year + 1), 
                        );

                        if (pickedDate != null) {
                          setModalState(() {
                            _selectedDate = pickedDate;
                            dayController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                      validator: (v) => v == null || v.isEmpty ? "Tanggal belajar tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: "Jam Belajar (Contoh: 15:00 - 17:00)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Jam tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number, 
                      decoration: const InputDecoration(
                        labelText: "Harga per Sesi (Rp)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payments_outlined),
                        hintText: "Contoh: 50000",
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Harga tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: "Catatan Tambahan (Contoh: Privat Materi...)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit_note_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _tambahJadwal,
                        child: const Text("Simpan Jadwal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text("Jadwal Mengajar Anda", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: currentUser == null
          ? const Center(child: Text("Sesi login berakhir."))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .where('mentor_id', isEqualTo: currentUser!.uid)
                  .where('status', isEqualTo: 'available') // 🔥 HANYA MENGUBAH BARIS INI (Filter status)
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
                        Icon(Icons.calendar_month_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text("Belum ada jadwal dibuat.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  );
                }

                var schedules = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    var data = schedules[index].data() as Map<String, dynamic>;
                    String docId = schedules[index].id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: const Icon(Icons.class_outlined, color: Colors.blue),
                        ),
                        title: Text(
                          "${data['day'] ?? '-'} (${data['time'] ?? '-'})",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              data['price'] != null && data['price'].toString().isNotEmpty
                                  ? "Tarif: Rp ${data['price']}"
                                  : "Tarif Belum Diatur",
                              style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
                            ),
                            if (data['note'] != null && data['note'].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Catatan: ${data['note']}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('schedules').doc(docId).delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleBottomSheet,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}