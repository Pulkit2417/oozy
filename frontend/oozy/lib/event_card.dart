import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'event_model.dart';
import 'event_details_screen.dart'; // We will create this placeholder screen next.

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  // Our "memory box" to remember if the card is expanded or not.
  bool _isExpanded = false;

  // Function to toggle the expanded state.
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // A smooth animation duration.
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Material(
        color: Colors.transparent, // To make the InkWell effect visible.
        child: InkWell(
          onTap: _toggleExpansion,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                // Conditionally show details and buttons when the card is expanded.
                if (_isExpanded) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${widget.event.peopleJoined} people have joined to ${widget.event.description} ${widget.event.locationDetail}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Details Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigates to a new page to show full details.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: widget.event),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryText,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero, // To make the button smaller.
                        ),
                        child: const Text('Details', style: TextStyle(color: AppColors.background)),
                      ),
                      const SizedBox(width: 8),
                      // Join Now Button
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement "Join Now" logic here (e.g., show a dialog).
                          print('Joined event: ${widget.event.title}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryText,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero, // To make the button smaller.
                        ),
                        child: const Text('Join Now', style: TextStyle(color: AppColors.background)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}