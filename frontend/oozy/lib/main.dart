// lib/main.dart

import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import our new splash screen

void main() {
  runApp(const OozyApp());
}

class OozyApp extends StatelessWidget {
  const OozyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oozy',
      // This removes the "debug" banner from the top right corner.
      debugShowCheckedModeBanner: false,
      // Set the SplashScreen as the first screen of the app.
      home: const SplashScreen(),
    );
  }
}