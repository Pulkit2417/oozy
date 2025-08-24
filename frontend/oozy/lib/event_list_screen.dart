import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'event_card.dart';
import 'event_model.dart';
import 'create_event_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A dummy list of events to display on the screen.
    final List<Event> dummyEvents = [
      Event(
        title: 'Paint with Dogs',
        description: 'paint with dogs',
        locationDetail: '2 kms from your location',
        peopleJoined: 50,
      ),
      Event(
        title: 'Book Reading at Lodhi Garden',
        description: 'to read books',
        locationDetail: '17 kms from your location',
        peopleJoined: 30,
      ),
      // Add more dummy events here if you like!
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'Join an Event',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: dummyEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(event: dummyEvents[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
            // The "Create an Event" button at the bottom.
            ElevatedButton(
              onPressed: () {
                // Navigates to the create event screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateEventScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Create an Event',
                style: TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}