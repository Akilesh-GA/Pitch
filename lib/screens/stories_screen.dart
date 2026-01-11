import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../widgets/story_card.dart';
import 'add_story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'package:flutter/gestures.dart';


class StoriesScreen extends StatefulWidget {
  final String userRole;

  const StoriesScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final List<Story> stories = [
    Story(
      companyName: "PunchBiz",
      headline:
      "AI-powered platform helping startups simplify business workflows.",
      image: "assets/images/punchbiz.png",
      founders:
      "Founded by Sriram Krishnamoorthy and team with a mission to transform business operations.",
      vision:
      "To empower every startup with intelligent workflow automation that makes business simple.",
      mission:
      "To deliver user-friendly software tools that enhance productivity, reduce manual work, and help teams operate efficiently at scale.",
      fullStory:
      "Our company provides AI vision analytics solutions that empower businesses to make informed decisions and drive growth.",
    ),
    Story(
      companyName: "Freshworks",
      headline:
      "Global SaaS company providing cloud-based customer and employee engagement software.",
      image: "assets/images/freshworks.jpeg",
      founders:
      "Founded in 2010 in Chennai, India, by Girish Mathrubootham and Shan Krishnasamy.",
      vision: "To simplify business operations and improve both customer and employee experiences.",
      mission: "To provide uncomplicated, powerful, and easy-to-use software.",
      fullStory: "Freshworks is a global SaaS company providing cloud-based software.",
    ),
  ];

  List<Story> filteredStories = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStories = stories;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchCompany(String query) {
    final results = stories
        .where((story) =>
        story.companyName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredStories = results;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen()),
                        );
                      },
                      child: Text(
                        "Role: ${widget.userRole}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    accountEmail: null,
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 40, color: Color(0xFF1ABC9C)),
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal[300]!, Color(0xFF1ABC9C)!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF1ABC9C),
                            child: const Icon(Icons.home, color: Colors.white),
                          ),
                          title: const Text("Home"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF1ABC9C),
                            child: const Icon(Icons.info, color: Colors.white),
                          ),
                          title: const Text("About"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF1ABC9C),
                            child: const Icon(Icons.book, color: Colors.white),
                          ),
                          title: const Text("Stories"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _logout,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.red], // Red gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 10, left: 10),
          child: Text(
            "Stories",
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: searchController,
                  onChanged: searchCompany,
                  decoration: InputDecoration(
                    hintText: "Explore startup stories",
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStories.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return StoryCard(story: filteredStories[index]);
                },
              ),
            ),
            if (widget.userRole.toLowerCase().trim() == 'story teller')
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddStoryScreen(userRole: widget.userRole),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        "Pitch",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
