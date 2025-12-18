import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'stories_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String errorMessage = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  final Color tColor = Color(0xFF1ABC9C);

  @override
  void initState() {
    super.initState();

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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: FadeTransition(
                    opacity: fadeAnim,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Welcome to Pitch",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Discover real founder journeys that inspire your path.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        SlideTransition(
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
                              children: [
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text("Forgot Password?",
                                        style: TextStyle(color: tColor)),
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
                                  child: Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: tColor,
                                      borderRadius: BorderRadius.circular(30),
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
                                        builder: (_) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Don't have an account? Sign Up",
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon, color: tColor),
        border: InputBorder.none,
      ),
    );
  }

  void _handleLogin() async {
    setState(() => errorMessage = "");

    try {
      // Sign in with Firebase Auth
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      String role = "investor"; // default fallback
      if (userDoc.exists && userDoc['role'] != null) {
        role = userDoc['role'].toString().toLowerCase(); // normalize to lowercase
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StoriesScreen(userRole: role),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Login failed");
    } catch (e) {
      setState(() => errorMessage = "Something went wrong");
    }
  }
}
