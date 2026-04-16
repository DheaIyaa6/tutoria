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
  int currentIndex = 0;
  List<Map<String, dynamic>> bookedMentors = [];

  void handleBooking(Map<String, dynamic> mentor) {
    setState(() {
      bookedMentors.add({...mentor, "status": "Ongoing"});
      currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onBooking: handleBooking),
      BookingScreen(
        bookedData: bookedMentors,
        onBack: () {
          setState(() {
            currentIndex = 0; // 🔥 balik ke Home
          });
        },
      ),
      const ProfileScreen(), // Halaman Profil
    ];

    return Scaffold(
      // Menggunakan IndexedStack langsung di body
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF1A237E),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home_rounded, 0),
            navItem(Icons.book_online_rounded, 1),
            navItem(Icons.person_rounded, 2),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      // Behavior hitTest membantu agar area klik icon lebih luas dan responsif
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: isActive ? Colors.white : Colors.white24),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 4,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            )
        ],
      ),
    );
  }
}
