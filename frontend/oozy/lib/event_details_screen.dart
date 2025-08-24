import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'event_model.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'This is the details screen for ${event.title}.',
          style: const TextStyle(color: AppColors.primaryText),
        ),
      ),
    );
  }
}