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

  // Tempat menampung data mentor yang berhasil di-booking
  final List<Map<String, dynamic>> _globalBookedData = [];

  @override
  Widget build(BuildContext context) {
    // Memasukkan halaman ke dalam list agar datanya sinkron dan real-time
    final List<Widget> pages = [
      // Index 0: Home Screen
      HomeScreen(
        onBooking: (mentorData) {
          setState(() {
            // Ketika ada mentor baru yang di-booking, tambahkan ke list global
            _globalBookedData.add({
              "name": mentorData["name"] ?? mentorData["full_name"] ?? "Mentor",
              "campus": mentorData["campus"] ?? "Universitas",
              "image": mentorData["image"] ?? "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200",
              "status": "Ongoing",
            });
            // Otomatis pindah ke tab Booking (Index 1) untuk melihat hasilnya
            _selectedIndex = 1;
          });
        },
      ),
      
      // Index 1: Booking Screen bawaanmu (Sekarang datanya otomatis terhubung!)
      BookingScreen(
        bookedData: _globalBookedData,
        onBack: () {
          setState(() {
            _selectedIndex = 0; // Balik ke Home kalau pencet back di appbar
          });
        },
      ),
      
      // Index 2: Profile Screen bawaanmu
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
          backgroundColor: const Color(0xFF1A237E), // Biru gelap tema utama
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