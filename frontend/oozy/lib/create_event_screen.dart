import 'package:flutter/material.dart';
import 'app_colors.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Event'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
      ),
      backgroundColor: AppColors.background,
      body: const Center(
        child: Text(
          'This is where you will create a new event!',
          style: TextStyle(color: AppColors.primaryText),
        ),
      ),
    );
  }
}