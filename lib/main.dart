import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StartupStoriesApp());
}

class StartupStoriesApp extends StatelessWidget {
  const StartupStoriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // ✅ KEEP SAME ENTRY POINT (NO LOGIC CHANGE)
      home: WelcomeScreen(),
    );
  }
}
