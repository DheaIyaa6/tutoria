import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookedData;
  const BookingScreen({super.key, required this.bookedData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("My Bookings", style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Color(0xFF1A237E),
            indicatorColor: Color(0xFF1A237E),
            tabs: [Tab(text: "Ongoing"), Tab(text: "Complete"), Tab(text: "Cancelled")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(bookedData.where((m) => m["status"] == "Ongoing").toList()),
            const Center(child: Text("No completed bookings yet")),
            const Center(child: Text("No cancelled bookings yet")),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const Center(child: Text("No data available"));
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(item["image"])),
            title: Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item["campus"]),
            trailing: const Text("Ongoing", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}