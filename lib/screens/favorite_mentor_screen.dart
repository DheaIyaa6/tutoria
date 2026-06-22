import 'package:flutter/material.dart';
import 'mentor_detail_screen.dart';

class FavoriteMentorScreen extends StatelessWidget {
  const FavoriteMentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> favoriteMentors = [
      {
        "name": "Alya Putri",
        "major": "Teknik Informatika",
        "campus": "Universitas Indonesia",
        "subjects": ["Flutter", "Dart"],
        "experience": "3 tahun mengajar mobile development",
        "price": 50000,
        "image": "https://randomuser.me/api/portraits/women/1.jpg",
      },
      {
        "name": "Rizky Pratama",
        "major": "Sistem Informasi",
        "campus": "ITS",
        "subjects": ["Java", "Database"],
        "experience": "2 tahun mengajar programming",
        "price": 45000,
        "image": "https://randomuser.me/api/portraits/men/2.jpg",
      },
      {
        "name": "Nadia Safira",
        "major": "Manajemen Bisnis",
        "campus": "UNAIR",
        "subjects": ["Business", "Marketing"],
        "experience": "4 tahun mentoring bisnis",
        "price": 60000,
        "image": "https://randomuser.me/api/portraits/women/3.jpg",
      },
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text("Favorite Mentors"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favoriteMentors.length,
        itemBuilder: (context, index) {
          final mentor = favoriteMentors[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MentorDetailScreen(
                      mentor: mentor,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(mentor["image"]),
              ),
              title: Text(
                mentor["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(mentor["major"]),
              trailing: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
