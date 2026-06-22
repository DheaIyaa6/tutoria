import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

class TransactionDetailScreen extends StatefulWidget {
  final String paymentMethod;
  final int total;

  const TransactionDetailScreen({
    super.key,
    required this.paymentMethod,
    required this.total,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late int remainingSeconds;
  Timer? timer;
  late String fakeNumber;

  @override
  void initState() {
    super.initState();
    remainingSeconds = 900; // 15 menit
    fakeNumber = generateFakeNumber();
    startTimer();
  }

  String generateFakeNumber() {
    Random random = Random();
    if (widget.paymentMethod == "QRIS") {
      return "QRIS-${100000 + random.nextInt(900000)}";
    }
    return "880608${random.nextInt(89999999) + 10000000}"; 
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Transaksi kedaluwarsa dan dibatalkan"),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        }
      },
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Selesaikan Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Menghilangkan tombol back biar user fokus bayar dulu
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  
                  // --- SECTION 1: COUNTDOWN TIMER CARD (PASTEL RED) ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2), // Merah pastel kalem
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined, color: Color(0xFFEF4444), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Batas Waktu Bayar: ",
                          style: TextStyle(color: Color(0xFF991B1B), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formatTime(remainingSeconds),
                          style: const TextStyle(color: Color(0xFFEF4444), fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SECTION 2: JUMLAH TAGIHAN ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "TOTAL TAGIHAN",
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rp ${widget.total}",
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Metode Pembayaran", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                            Text(
                              widget.paymentMethod,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- SECTION 3: KODE BAYAR ATAU QRIS IMAGE ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: widget.paymentMethod == "QRIS"
                        ? Column(
                            children: [
                              const Text(
                                "SCAN KODE QRIS BERIKUT",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                              ),
                              const SizedBox(height: 16),
                              // Mengambil placeholder QR Code asli biar interaktif dan ga jadul
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${fakeNumber}",
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                fakeNumber,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "NOMOR VIRTUAL ACCOUNT / KODE BAYAR",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      fakeNumber,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: 1),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: fakeNumber));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Nomor bayar berhasil disalin! 📋"),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.copy_rounded, color: Color(0xFF1A237E), size: 18),
                                          SizedBox(width: 4),
                                          Text(
                                            "Salin",
                                            style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 13),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),

          // --- SECTION 4: ACTIONS BOTTOM BAR ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, -4)),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E), // Biru gelap premium senada dengan halaman lainnya
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        // Kembali ke halaman sebelumnya dan mengirim data transaksi sukses (true)
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Saya Sudah Bayar",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tombol Batalkan Transaksi yang rapi dan tidak merusak estetika
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Batalkan Transaksi",
                      style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}