import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../screens/company_detail_screen.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CompanyDetailScreen(story: story),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              spreadRadius: -3,
              offset: Offset(0, 8),
              color: Colors.black.withOpacity(0.08),
            )
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: story.companyName,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  story.image,
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.companyName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    story.headline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
