import 'package:flutter/material.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final List<Map<String, dynamic>> vouchers = [
    {
      "title": "NEW USER",
      "discount": "50% OFF",
      "desc": "Valid for first booking only",
      "claimed": false,
    },
    {
      "title": "HEMAT10",
      "discount": "Rp10.000 OFF",
      "desc": "Minimum booking Rp50.000",
      "claimed": false,
    },
    {
      "title": "STUDENT25",
      "discount": "25% OFF",
      "desc": "Special student discount",
      "claimed": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text("Promo / Voucher"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final voucher = vouchers[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(voucher["discount"]),
                      Text(
                        voucher["desc"],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: voucher["claimed"]
                          ? Colors.grey
                          : const Color(0xFF1A237E),
                    ),
                    onPressed: voucher["claimed"]
                        ? null
                        : () {
                            setState(() {
                              voucher["claimed"] = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${voucher["title"]} claimed!",
                                ),
                              ),
                            );
                          },
                    child: Text(
                      voucher["claimed"] ? "Claimed" : "Claim",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ]),
          );
        },
      ),
    );
  }
}
