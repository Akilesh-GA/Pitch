import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../widgets/story_card.dart';
import 'package:flutter/gestures.dart';
import 'add_story_screen.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final List<Story> stories = [
    Story(
      companyName: "PunchBiz",
      headline: "AI-powered platform helping startups simplify business workflows.",
      image: "assets/images/punchbiz.png",
      founders:
      "Founded by Sriram Krishnamoorthy and team with a mission to transform business operations.",
      vision:
      "To empower every startup with intelligent workflow automation that makes business simple.",
      mission:
      "To deliver user-friendly software tools that enhance productivity, reduce manual work, and help teams operate efficiently at scale.",
      fullStory:
      "Our company provides AI vision analytics solutions that empower businesses to make informed decisions and drive growth. "
          "We leverage the latest advancements in AI technology to provide businesses with the tools and insights they need to analyze and utilize their data. "
          "Our solutions are designed to integrate seamlessly into a variety of business operations and decision-making processes, delivering intelligence and insights to drive efficiency, accuracy, and success. "
          "Our team of experts works closely with clients to understand their unique needs and deliver customized solutions that meet their specific requirements. "
          "We are committed to continuously innovating and improving our technology, ensuring that we remain at the forefront of the industry and deliver the most advanced AI vision analytics solutions to our clients.",
    ),
    Story(
      companyName: "Freshworks",
      headline:
      "Global SaaS company providing cloud-based customer and employee engagement software.",
      image: "assets/images/freshworks.jpeg",
      founders:
      "Founded in 2010 in Chennai, India, by Girish Mathrubootham and Shan Krishnasamy.",
      vision:
      "To simplify business operations and improve both customer and employee experiences through user-friendly SaaS solutions.",
      mission:
      "To provide uncomplicated, powerful, and easy-to-use software that replaces complex legacy systems, improving efficiency for businesses of all sizes.",
      fullStory:
      "Freshworks is a global SaaS company providing cloud-based software for customer and employee engagement. "
          "It is known for its user-friendly tools like Freshdesk (support), Freshservice (ITSM), and Freshsales (CRM). "
          "The company leverages AI technologies such as Freddy AI to automate tasks, reduce friction, and provide faster service. "
          "Freshworks helps businesses of all sizes simplify operations in customer service, IT, HR, and sales, focusing on easy implementation and rapid results. "
          "Headquartered in San Mateo, California, with significant operations in India, it serves over 74,000 customers globally.",
    ),
    Story(
      companyName: "BitsCrunch",
      headline:
      "AI-enabled decentralized blockchain data analytics and forensics platform.",
      image: "assets/images/bitscrunch.png",
      founders: "Founded in 2019 by Vijay Pravin Maharajan and Saravanan Jaichandaran.",
      vision:
      "To make the blockchain ecosystem safer and more reliable by blending Artificial Intelligence (AI) with blockchain technology.",
      mission:
      "To provide multi-chain insights for NFTs, tokens, and other digital assets, enabling fraud detection, risk assessment, and enhanced transparency in the Web3 ecosystem.",
      fullStory:
      "BitsCrunch is an AI-enabled decentralized blockchain data analytics and forensics company that provides multi-chain insights for NFTs, tokens, and other digital assets.",
    ),
    Story(
      companyName: "GoFloaters",
      headline:
      "Indian hybrid workspace platform offering on-demand meeting rooms, hot desks, and virtual offices.",
      image: "assets/images/gofloaters.jpeg",
      founders:
      "Founded in Chennai, India, by Ankur Sinha and team, aiming to simplify access to professional workspaces.",
      vision:
      "To enable flexible, accessible, and professional workspaces for freelancers, teams, and companies across India.",
      mission:
      "To provide on-demand, pay-per-use workspace solutions that remove long-term commitments and make hybrid work seamless.",
      fullStory:
      "GoFloaters is an Indian hybrid workspace platform that allows users to book meeting rooms, hot desks, and virtual offices on-demand.",
    ),
    Story(
      companyName: "Ippo Pay",
      headline:
      "Indian fintech company providing digital payment solutions for small businesses, freelancers, and rural merchants.",
      image: "assets/images/ippopay.jpeg",
      founders:
      "Founded by Mohan Karuppiah & Jaikumar, aiming to empower local entrepreneurs with easy-to-use payment infrastructure.",
      vision:
      "To enable digital inclusion by bringing small, local businesses in India’s hinterlands into the digital payment ecosystem.",
      mission:
      "To provide simple, user-friendly, and secure payment tools like UPI, QR codes, payment links, and APIs, supporting multi-currency payments and subscription management.",
      fullStory:
      "Ippo Pay is an Indian fintech company that provides localized digital payment solutions for MSMEs, freelancers, and rural merchants.",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 10, left: 10),
          child: Text(
            "Startup Stories",
            style: TextStyle(
                color: Color(0xFF1ABC9C), fontWeight: FontWeight.bold),
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
                  // Apply simple fade + scale animation for each card
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + index * 100),
                    curve: Curves.easeOut,
                    tween: Tween(begin: 0.8, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: StoryCard(story: filteredStories[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStoryScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF1ABC9C).withOpacity(0.75),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      "Pitch",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
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
