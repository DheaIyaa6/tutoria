import 'package:flutter/material.dart';
import 'transaction_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> mentor;
  final Function(Map<String, dynamic>)? onBooking;

  const CheckoutScreen({
    super.key,
    required this.mentor,
    this.onBooking, // 
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = "DANA";

  final List<Map<String, dynamic>> paymentMethods = [
    {"id": "DANA", "name": "DANA Wallet", "icon": Icons.account_balance_wallet_rounded, "color": Colors.blue},
    {"id": "OVO", "name": "OVO Cash", "icon": Icons.wallet_membership_rounded, "color": Colors.purple},
    {"id": "QRIS", "name": "QRIS (Gopay/ShopeePay/dll)", "icon": Icons.qr_code_2_rounded, "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    final int serviceFee = 5000;
    final int total = widget.mentor["price"] + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      appBar: AppBar(
        title: const Text(
          "Review Checkout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Konten Utama yang bisa di-scroll jika layar HP kecil
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KARTU INFORMASI MENTOR
                  const Text(
                    "Detail Mentor",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: const Icon(Icons.person_rounded, color: Color(0xFF1A237E)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mentor["name"],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Universitas ${widget.mentor["campus"]} • ${widget.mentor["major"]}",
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- METODE PEMBAYARAN CUSTOM ---
                  const Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = paymentMethods[index];
                      final isSelected = selectedPayment == method["id"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPayment = method["id"];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1A237E) : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: const Color(0xFF1A237E).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Icon(method["icon"], color: isSelected ? const Color(0xFF1A237E) : const Color(0xFF94A3B8), size: 24),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  method["name"],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 14,
                                    color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                              // Custom Radio Bulat Estetik
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF1A237E) : const Color(0xFFCBD5E1),
                                    width: isSelected ? 6 : 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // --- RINCIAN BIAYA ---
                  const Text(
                    "Ringkasan Pembayaran",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow("Harga Sesi Mentor", "Rp ${widget.mentor["price"]}", isTotal: false),
                        const SizedBox(height: 10),
                        _buildPriceRow("Biaya Layanan Aplikasi", "Rp $serviceFee", isTotal: false),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                        ),
                        _buildPriceRow("Total Pembayaran", "Rp $total", isTotal: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- STICKY BOTTOM BUTTON ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E), // Biru gelap premium senada dengan HomeScreen kita
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionDetailScreen(
                          paymentMethod: selectedPayment,
                          total: total,
                        ),
                      ),
                    );

                    if (result == true) {
                      // 2. KETIKA SELESAI PEMBAYARAN SUKSES, PICU PENGIRIMAN DATA KE MAINSCREEN
                      if (widget.onBooking != null) {
                        widget.onBooking!({
                          "name": widget.mentor["name"],
                          "campus": widget.mentor["campus"],
                          "image": widget.mentor["image"] ?? "https://randomuser.me/api/portraits/women/1.jpg",
                          "status": "Ongoing"
                        });
                      }
                      
                      // Mengembalikan sinyal true ke halaman Home
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    "Konfirmasi & Bayar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget kecil untuk merapikan teks baris harga kiri-kanan
  Widget _buildPriceRow(String label, String value, {required bool isTotal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFF1A237E) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}