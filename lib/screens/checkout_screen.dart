import 'package:flutter/material.dart';
import 'transaction_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> mentor;

  const CheckoutScreen({
    super.key,
    required this.mentor,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = "DANA";

  @override
  Widget build(BuildContext context) {
    final int serviceFee = 5000;
    final int total = widget.mentor["price"] + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mentor: ${widget.mentor["name"]}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text("Harga Mentor: Rp ${widget.mentor["price"]}"),
            Text("Biaya Aplikasi: Rp $serviceFee"),
            const Divider(),
            Text(
              "Total: Rp $total",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            RadioListTile(
              title: const Text("DANA"),
              value: "DANA",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("OVO"),
              value: "OVO",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("QRIS"),
              value: "QRIS",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                    Navigator.pop(context, true);
                  }
                },
                child: const Text("Bayar Sekarang"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
