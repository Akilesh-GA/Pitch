import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // 🔹 Load profile image from Firestore
  Future<void> _loadProfileImage() async {
    if (user == null) return;

    try {
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        _photoUrl = doc.data()?['photoUrl'];
      });
    } catch (e) {
      debugPrint("Failed to load profile image: $e");
    }
  }

  // 🔹 PICK + UPLOAD IMAGE TO FIREBASE
  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user!.uid}.jpg');

      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final url = await ref.getDownloadURL();

        // Update Firestore safely
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'photoUrl': url});

        setState(() {
          _pickedImage = file;
          _photoUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final name = data['name'] ?? "Anonymous";
          final email = data['email'] ?? user!.email ?? "";
          final role = data['role'] ?? "User";
          final dob = data['dob'] ?? "Not set";
          final phone = data['phone'] ?? "Not set";
          final photoUrl = data['photoUrl'] ?? _photoUrl;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(name, role, photoUrl),
                const SizedBox(height: 90),
                _buildProfileCard(
                  email: email,
                  role: role,
                  dob: dob,
                  phone: phone,
                  onEdit: () {
                    _showEditSheet(context, name, dob, phone);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String name, String role, String? photoUrl) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05)
              ],
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.white.withOpacity(0.05)),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAndUploadImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!) as ImageProvider
                            : (photoUrl != null ? NetworkImage(photoUrl) : null),
                        child: _pickedImage == null && photoUrl == null
                            ? const Icon(Icons.person,
                            size: 60, color: Color(0xFF1ABC9C))
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF1ABC9C),
                        child: const Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                role,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard({
    required String email,
    required String role,
    required String dob,
    required String phone,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _infoTile(Icons.email, "Email", email),
            _infoTile(Icons.badge, "Role", role),
            _infoTile(Icons.phone, "Phone", phone),
            _infoTile(Icons.cake, "Date of Birth", dob),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1ABC9C),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAF9F6),
        child: Icon(icon, color: const Color(0xFF1ABC9C)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value, style: const TextStyle(color: Colors.black87)),
    );
  }

  void _showEditSheet(
      BuildContext context, String currentName, String currentDob, String currentPhone) {
    final nameController = TextEditingController(text: currentName);
    final phoneController =
    TextEditingController(text: currentPhone == "Not set" ? "" : currentPhone);
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "User Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? currentDob
                                : DateFormat('yyyy-MM-dd').format(selectedDate!),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .update({
                          'name': nameController.text.trim(),
                          'phone': phoneController.text.trim().isNotEmpty
                              ? phoneController.text.trim()
                              : null,
                          'dob': selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : null,
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1ABC9C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
