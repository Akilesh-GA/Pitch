import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitch/firebase_options.dart';
import 'stories_screen.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  String selectedRole = "Investor"; // Default selected
  String errorMessage = "";

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  final Color tColor = Color(0xFF1ABC9C); // Turquoise blue

  @override
  void initState() {
    super.initState();
    _initializeFirebase();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: fadeAnim,
                          child: Column(
                            children: [
                              Text(
                                "Create Your Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Connect, learn, and grow with founders.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        FadeTransition(
                          opacity: fadeAnim,
                          child: SlideTransition(
                            position: slideAnim,
                            child: Container(
                              padding: EdgeInsets.all(25),
                              width: 340,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 25,
                                    spreadRadius: -5,
                                    offset: Offset(0, 10),
                                    color: Colors.black.withOpacity(0.08),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      _buildToggle("Investor"),
                                      _buildToggle("Story Teller"),
                                      _buildToggle("Admin"),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  _buildInputField(
                                    controller: nameController,
                                    label: "Name",
                                    icon: Icons.person_outline,
                                  ),
                                  SizedBox(height: 18),

                                  _buildInputField(
                                    controller: phoneController,
                                    label: "Phone Number",
                                    icon: Icons.phone_outlined,
                                  ),
                                  SizedBox(height: 18),

                                  _buildInputField(
                                    controller: emailController,
                                    label: "Email",
                                    icon: Icons.email_outlined,
                                  ),
                                  SizedBox(height: 18),

                                  _buildInputField(
                                    controller: passwordController,
                                    label: "Password",
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                  ),
                                  SizedBox(height: 18),

                                  if (errorMessage.isNotEmpty)
                                    Text(
                                      errorMessage,
                                      style: TextStyle(
                                        color: tColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: _handleRegister,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: 55,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: tColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: tColor.withOpacity(0.4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 30),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => LoginScreen()),
                                      );
                                    },
                                    child: Text(
                                      "Already have an account? Login",
                                      style: TextStyle(
                                        color: tColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggle(String role) {
    bool isSelected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRole = role),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? tColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              role,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: tColor,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon, color: tColor),
        labelStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  void _handleRegister() async {
    setState(() => errorMessage = "");

    String name = nameController.text.trim().toLowerCase();
    String phone = phoneController.text.trim().toLowerCase();
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    String role = selectedRole.toLowerCase();

    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "All fields are required");
      return;
    }

    if (!email.contains("@")) {
      setState(() => errorMessage = "Invalid email format");
      return;
    }

    if (password.length < 6) {
      setState(() => errorMessage = "Password must be at least 6 characters");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'phone': phone,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Registration failed");
    } catch (e) {
      setState(() => errorMessage = "An unexpected error occurred");
    }
  }
}
