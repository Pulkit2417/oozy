// lib/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to the login screen.
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // The 'oozy' logo text.
            Text(
              'oozy',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryText,
              ),
            ),
            // The tagline text.
            Text(
              'Strangers today, Stories Tomorrow',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      )
    );
  }
}