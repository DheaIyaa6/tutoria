import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'booking_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List penyimpan state booking global agar real-time terintegrasi
  final List<Map<String, dynamic>> _globalBookedData = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onBooking: (mentorData) {
          setState(() {
            // SINKRONISASI KEY: Menggunakan key 'day' agar dibaca oleh card BookingScreen Anda
            _globalBookedData.add({
              "name": mentorData["name"] ?? "Mentor",
              "campus": mentorData["campus"] ?? "Universitas",
              "major": mentorData["major"] ?? "Jurusan",
              "image": mentorData["image"] ?? "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200",
              "status": mentorData["status"] ?? "Ongoing",
              "day": mentorData["day"] ?? "Tanggal Tidak Set", // <-- Menggunakan key 'day' yang konsisten
              "time": mentorData["time"] ?? "Jam Tidak Set",
            });
            // Alihkan pandangan tab langsung ke Booking Screen setelah sukses
            _selectedIndex = 1;
          });
        },
      ),
      BookingScreen(
        bookedData: _globalBookedData,
        onBack: () {
          setState(() {
            _selectedIndex = 0; 
          });
        },
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A237E), 
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.4),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_rounded), label: 'Booking'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}