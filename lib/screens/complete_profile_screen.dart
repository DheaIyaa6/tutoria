import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final schoolController = TextEditingController();
  final classController = TextEditingController();
  final birthdayController = TextEditingController();

  void createAccount() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully"),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      });
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2007),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthdayController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  InputDecoration customInput(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF4F7FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND ATAS
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset(
              'assets/images/abstrakpojoklogin.png',
              width: 200,
            ),
          ),

          /// BACKGROUND BAWAH
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bottomlogin.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/backlogin.png',
                        width: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOGO
                  Image.asset(
                    'assets/images/Tutoria.png',
                    height: 50,
                  ),

                  const SizedBox(height: 20),

                  /// ILLUSTRATION
                  Image.asset(
                    'assets/images/signuporang.png',
                    height: 140,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Complete Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// FORM CARD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// PHONE
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone number wajib diisi";
                              }
                              return null;
                            },
                            decoration: customInput(
                              "Phone Number",
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// SCHOOL
                          TextFormField(
                            controller: schoolController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "School wajib diisi";
                              }
                              return null;
                            },
                            decoration: customInput(
                              "School",
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// CLASS
                          TextFormField(
                            controller: classController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Class wajib diisi";
                              }
                              return null;
                            },
                            decoration: customInput(
                              "Class",
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// BIRTHDAY
                          TextFormField(
                            controller: birthdayController,
                            readOnly: true,
                            onTap: pickDate,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Birthday wajib diisi";
                              }
                              return null;
                            },
                            decoration: customInput(
                              "Birthday",
                            ).copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// CREATE ACCOUNT BUTTON
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: GestureDetector(
                      onTap: createAccount,
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF42A5F5),
                              Color(0xFF1E88E5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
