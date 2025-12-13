import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitch/firebase_options.dart';
import 'stories_screen.dart';
import 'register_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String selectedRole = "User";
  String errorMessage = "";

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
                                "Welcome to Pitch",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Discover real founder journeys that inspire your path.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
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
                                  SizedBox(height: 20),

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

                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: tColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),

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
                                    onTap: _handleLogin,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: 55,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: tColor,
                                        borderRadius: BorderRadius.circular(30),
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
                                          "Login",
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
                                              builder: (_) => RegisterScreen()));
                                    },
                                    child: Text(
                                      "Don't have an account? Sign Up",
                                      style: TextStyle(
                                        color: tColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
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
            borderRadius: BorderRadius.circular(15),
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

  void _handleLogin() async {
    setState(() => errorMessage = "");

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please enter email and password");
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
      // Firebase login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check role if needed from Firestore later
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StoriesScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Login failed");
    } catch (e) {
      setState(() => errorMessage = "An unexpected error occurred");
    }
  }
}
