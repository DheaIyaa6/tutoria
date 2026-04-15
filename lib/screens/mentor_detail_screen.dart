import 'package:flutter/material.dart';

class MentorDetailScreen extends StatelessWidget {
  final Map mentor;

  const MentorDetailScreen({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mentor["name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(mentor["image"]),
            ),

            const SizedBox(height: 20),

            Text(
              mentor["name"],
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text("${mentor["major"]} - ${mentor["campus"]}"),

            const SizedBox(height: 10),

            Text("Bidang: ${mentor["subjects"].join(", ")}"),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pengalaman:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 6),

            Text(mentor["experience"]),
          ],
        ),
      ),
    );
  }
}