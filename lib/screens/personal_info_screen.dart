import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isEditingSchool = false;
  bool isEditingClass = false;

  final emailController = TextEditingController(text: "dimas@gmail.com");

  final phoneController = TextEditingController(text: "08123456789");

  final schoolController = TextEditingController(text: "SMKN 1 Surabaya");

  final classController = TextEditingController(text: "XII RPL 2");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text("Personal Information"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStaticField("Full Name", "Dimas Anggara"),
            _buildStaticField("Birthday", "12 August 2007"),
            _buildEditableField(
              "Email",
              emailController,
              isEditingEmail,
              () {
                setState(() {
                  isEditingEmail = !isEditingEmail;
                });
              },
            ),
            _buildEditableField(
              "Phone Number",
              phoneController,
              isEditingPhone,
              () {
                setState(() {
                  isEditingPhone = !isEditingPhone;
                });
              },
            ),
            _buildEditableField(
              "School",
              schoolController,
              isEditingSchool,
              () {
                setState(() {
                  isEditingSchool = !isEditingSchool;
                });
              },
            ),
            _buildEditableField(
              "Class",
              classController,
              isEditingClass,
              () {
                setState(() {
                  isEditingClass = !isEditingClass;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Profile updated successfully",
                      ),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticField(String title, String value) {
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
          Text(title),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String title,
    TextEditingController controller,
    bool isEditing,
    VoidCallback onEdit,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  isEditing ? "Done" : "Edit",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          )
        ],
      ),
    );
  }
}
