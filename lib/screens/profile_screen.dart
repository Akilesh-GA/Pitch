import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/firebase_utils.dart'; // Make sure this exists

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Color(0xFF1ABC9C),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1ABC9C)),
        elevation: 1,
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("No user logged in"))
            : StreamBuilder(
          stream: FirebaseUtils.getUserStream(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data?.data() == null) {
              return const Center(child: Text("User data not found"));
            }

            final data = snapshot.data!.data(); // Map<String, dynamic>?

            final String name = data?['name'] ?? "Anonymous";
            final String role = data?['role'] ?? "Unknown";
            final String email = data?['email'] ?? "Not provided";

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF1ABC9C),
                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      role,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
