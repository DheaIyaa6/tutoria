import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'splash_screen.dart'; // ← Pastikan import ke file Splash Screen kamu sudah benar

class MentorSignupScreen extends StatefulWidget {
  const MentorSignupScreen({super.key});

  @override
  State<MentorSignupScreen> createState() => _MentorSignupScreenState();
}

class _MentorSignupScreenState extends State<MentorSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final campusController = TextEditingController();
  final facultyController = TextEditingController(); 
  final majorController = TextEditingController();   
  final districtController = TextEditingController(); 
  final semesterController = TextEditingController();
  final cvLinkController = TextEditingController(); 
  final transcriptLinkController = TextEditingController(); 
  final bioController = TextEditingController(); 
  final reasonController = TextEditingController(); 

  String? selectedSubject; 
  final FirebaseService _firebaseService = FirebaseService();
  bool obscure = true;

  Future<void> prosesSignupMentor() async {
    if (selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih bidang yang ingin diajar!")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await _firebaseService.registerMentor(
          email: emailController.text,
          password: passwordController.text,
          fullName: nameController.text,
          age: ageController.text,
          campus: campusController.text,
          faculty: facultyController.text,
          major: majorController.text,
          teachingSubject: selectedSubject!,
          district: districtController.text,
          semester: semesterController.text,
          cvLink: cvLinkController.text,
          transcriptLink: transcriptLinkController.text,
          bio: bioController.text,
          reason: reasonController.text,
        );

        if (mounted) Navigator.pop(context); // Tutup loading indikator

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                "Pendaftaran Berhasil", 
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
              content: const Text(
                "Data Anda telah dikirim ke Admin Tutoria.\n\nStatus akun Anda saat ini: PENDING. Silakan tunggu maksimal 24 jam untuk konfirmasi aktivasi akun.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup Dialog terlebih dahulu
                    
                    // Alur Baru: Reset tumpukan page dan tendang balik ke Splash Screen utama 🚀
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SplashScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "OK, Mengerti", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))
                  ),
                )
              ],
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Terjadi kesalahan.")));
      } catch (e) {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6, top: 12),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E88E5)),
      ),
    );
  }

  InputDecoration customInput(String hintExample, {IconData? icon}) {
    return InputDecoration(
      hintText: hintExample,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade400, size: 20) : null,
      filled: true,
      fillColor: const Color(0xFFF4F7FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset('assets/images/abstrakpojoklogin.png', width: 180),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/images/backlogin.png', width: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/Tutoria.png', height: 50),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      "Sign Up Sebagai Mentor",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// SECTION 1: AKUN DASAR
                  const Text("INFORMASI AKUN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey, fontSize: 12)),
                  const Divider(),
                  
                  _buildInputLabel("Nama Lengkap"),
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                    decoration: customInput("Contoh: Aditya Airlangga", icon: Icons.person),
                  ),
                  
                  _buildInputLabel("Email Resmi"),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => !v!.contains("@") ? "Email tidak valid" : null,
                    decoration: customInput("Contoh: aditya.airlangga@gmail.com", icon: Icons.email),
                  ),
                  
                  _buildInputLabel("Password"),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscure,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.length < 8 ? "Minimal 8 karakter" : null,
                    decoration: customInput("Masukkan kata sandi minimal 8 karakter", icon: Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// SECTION 2: KUALIFIKASI AKADEMIK
                  const Text("KUALIFIKASI AKADEMIK", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey, fontSize: 12)),
                  const Divider(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel("Usia"),
                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black),
                              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                              decoration: customInput("Contoh: 21"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel("Semester"),
                            TextFormField(
                              controller: semesterController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black),
                              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                              decoration: customInput("Contoh: 6"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  _buildInputLabel("Asal Kampus / Universitas"),
                  TextFormField(
                    controller: campusController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Asal Kampus wajib diisi" : null,
                    decoration: customInput("Contoh: Universitas Airlangga", icon: Icons.school),
                  ),

                  _buildInputLabel("Fakultas"),
                  TextFormField(
                    controller: facultyController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Fakultas wajib diisi" : null,
                    decoration: customInput("Contoh: Fakultas Sains dan Teknologi", icon: Icons.domain),
                  ),

                  _buildInputLabel("Jurusan / Program Studi"),
                  TextFormField(
                    controller: majorController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Jurusan wajib diisi" : null,
                    decoration: customInput("Contoh: S1 Matematika", icon: Icons.polyline),
                  ),

                  _buildInputLabel("Bidang yang Ingin Diajar"),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firebaseService.getTeachingSubjects(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: LinearProgressIndicator());
                      }
                      
                      var docs = snapshot.data!.docs;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSubject,
                            hint: Text(
                              "Pilih Bidang Keahlian Anda", 
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            ),
                            isExpanded: true,
                            dropdownColor: const Color(0xFFF4F7FB),
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            items: docs.map((doc) {
                              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                              return DropdownMenuItem<String>(
                                value: data['name'],
                                child: Text(data['name'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => selectedSubject = val);
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  _buildInputLabel("Kecamatan Domisili Saat Ini"),
                  TextFormField(
                    controller: districtController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Kecamatan wajib diisi" : null,
                    decoration: customInput("Contoh: Lowokwaru", icon: Icons.location_on),
                  ),

                  const SizedBox(height: 25),

                  /// SECTION 3: BERKAS & ALASAN
                  const Text("DOKUMEN & RIWAYAT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey, fontSize: 12)),
                  const Divider(),
                  
                  _buildInputLabel("Link Google Drive CV"),
                  TextFormField(
                    controller: cvLinkController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Tautan CV wajib diisi" : null,
                    decoration: customInput("Contoh: https://drive.google.com/...", icon: Icons.link),
                  ),
                  
                  _buildInputLabel("Link Google Drive Transkrip Nilai"),
                  TextFormField(
                    controller: transcriptLinkController,
                    style: const TextStyle(color: Colors.black),
                    validator: (v) => v!.isEmpty ? "Tautan Transkrip wajib diisi" : null,
                    decoration: customInput("Contoh: https://drive.google.com/...", icon: Icons.link),
                  ),
                  
                  _buildInputLabel("Riwayat Hidup Singkat / Pengalaman"),
                  TextFormField(
                    controller: bioController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black),
                    decoration: customInput("Contoh: Berpengalaman mengajar matematika SMA selama 1 tahun, aktif di organisasi BEM Kampus..."),
                  ),
                  
                  _buildInputLabel("Alasan Ingin Bergabung Menjadi Mentor"),
                  TextFormField(
                    controller: reasonController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black),
                    decoration: customInput("Contoh: Ingin mendedikasikan ilmu akademik saya untuk membantu siswa..."),
                  ),

                  const SizedBox(height: 35),

                  GestureDetector(
                    onTap: prosesSignupMentor,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)]),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          "KIRIM PENDAFTARAN MENTOR",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}