import 'package:flutter/material.dart';
import '../models/story_model.dart';

class StoryDetailScreen extends StatelessWidget {
  final Story story;

  StoryDetailScreen({required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(story.companyName)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(story.image, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),

            Text(
              story.companyName,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            Text(
              story.fullStory,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
