import 'package:flutter/material.dart';
import '../models/story_model.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Story story;
  CompanyDetailScreen({required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.companyName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Company Logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  story.image,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 20),

            /// Company Name
            Center(
              child: Text(
                story.companyName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            /// Headline
            Center(
              child: Text(
                story.headline,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 25),

            /// --- Founders Section ---
            if (story.founders != null) ...[
              _buildSection("Founders", story.founders!),
            ],

            /// --- Vision Section ---
            if (story.vision != null) ...[
              _buildSection("Vision", story.vision!),
            ],

            /// --- Mission Section ---
            if (story.mission != null) ...[
              _buildSection("Mission", story.mission!),
            ],

            /// --- Company Story Section ---
            if (story.fullStory != null) ...[
              _buildSection("Story", story.fullStory!),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper widget to format each section with spacing
  Widget _buildSection(String title, String content) {
    // Split the content into paragraphs by '. '
    List<String> paragraphs = content.split('. ').map((e) => e.trim()).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...paragraphs.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              p.endsWith('.') ? p : '$p.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          )),
        ],
      ),
    );
  }
}
