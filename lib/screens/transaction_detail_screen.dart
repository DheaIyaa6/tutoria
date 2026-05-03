import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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

    return "08${random.nextInt(999999999)}";
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

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Transaksi dibatalkan"),
            ),
          );

          Navigator.pop(context);
        }
      },
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;

    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Metode: ${widget.paymentMethod}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              "Bayar ke: $fakeNumber",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Total: Rp ${widget.total}",
            ),
            const SizedBox(height: 20),
            Text(
              "Sisa waktu: ${formatTime(remainingSeconds)}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Saya Sudah Bayar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
