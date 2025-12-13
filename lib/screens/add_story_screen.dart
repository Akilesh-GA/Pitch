import 'package:flutter/material.dart';
import 'stories_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddStoryScreen extends StatefulWidget {
  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen>
    with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  File? logoFile;

  String errorMessage = "";

  // made nullable to avoid LateInitializationError
  AnimationController? _controller;
  Animation<double>? fadeAnim;
  Animation<Offset>? slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOut),
    );

    // null-aware call (safety)
    _controller?.forward();
  }

  @override
  void dispose() {
    // null-safe dispose
    _controller?.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ---- IMAGE PICKER ----
  Future<void> pickLogo() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (picked != null) {
        setState(() {
          logoFile = File(picked.path);
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Unable to pick image. Check permissions.";
      });
    }
  }

  // ---- SUBMIT ----
  void _handleSubmit() {
    setState(() => errorMessage = "");

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        logoFile == null) {
      setState(() => errorMessage = "All fields and logo are required");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StoriesScreen()),
    );
  }

  // ---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Fallback animations in case initState didn't run or fields are null
    final Animation<double> opacityAnim =
        fadeAnim ?? AlwaysStoppedAnimation<double>(1.0);
    final Animation<Offset> offsetAnim =
        slideAnim ?? AlwaysStoppedAnimation<Offset>(Offset.zero);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 100),

                      FadeTransition(
                        opacity: opacityAnim,
                        child: Column(
                          children: [
                            Text(
                              "Share Your Startup Story",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Showcase your company and pitch your journey.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      FadeTransition(
                        opacity: opacityAnim,
                        child: SlideTransition(
                          position: offsetAnim,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.all(25),
                              width: 340,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 6),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: pickLogo,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border:
                                        Border.all(color: Colors.grey),
                                        color: Colors.black.withOpacity(0.05),
                                        image: logoFile != null
                                            ? DecorationImage(
                                          image:
                                          FileImage(logoFile!),
                                          fit: BoxFit.cover,
                                        )
                                            : null,
                                      ),
                                      child: logoFile == null
                                          ? Icon(Icons.add_a_photo,
                                          color: Colors.black54)
                                          : null,
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  _buildInput(
                                    controller: titleController,
                                    label: "Story Title",
                                    icon: Icons.title,
                                  ),

                                  SizedBox(height: 15),

                                  _buildInput(
                                    controller: descriptionController,
                                    label: "Share Your Story",
                                    icon: Icons.description_rounded,
                                    maxLines: 4,
                                  ),

                                  SizedBox(height: 15),

                                  if (errorMessage.isNotEmpty)
                                    Text(
                                      errorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: _handleSubmit,
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1ABC9C),
                                            Color(0xFF16A085),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Submit Story",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => StoriesScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Back to Stories",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // -------------------- INPUT FIELD --------------------
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Color(0xFF1ABC9C)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: label,
              contentPadding:
              EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }
}
