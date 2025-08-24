import 'package:flutter/material.dart';
import 'package:oozy/event_list_screen.dart';
import 'app_colors.dart';

class InterestsSelectionScreen extends StatefulWidget {
  // We can receive data from the previous screen here.
  final List<String> selectedLocations;

  const InterestsSelectionScreen({
    super.key,
    required this.selectedLocations,
  });

  @override
  State<InterestsSelectionScreen> createState() => _InterestsSelectionScreenState();
}

class _InterestsSelectionScreenState extends State<InterestsSelectionScreen> {
  // A list of available interests.
  final List<String> _interests = [
    'Art and Creativity',
    'Books and conversations',
    'Games and Entertainment',
    'Health and Movement',
    'Travel and Discovery',
    'Food & Coffee',
    'Social Impact / Volunteering',
    'Others',
  ];

  // A Set to store the selected interests.
  final Set<String> _selectedInterests = {};

  // This function is called when an interest is tapped.
  void _onInterestSelected(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  // This function handles the "Continue" button logic.
  void _onContinuePressed() {
    // This is where you would handle the final submission of all data.
    // We have access to both selected locations and interests!
    print('Final selections:');
    print('Locations: ${widget.selectedLocations}');
    print('Interests: ${_selectedInterests.toList()}');

    // TODO: Implement the logic to send this data to your backend
    // and then navigate to the home screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventListScreen(
          
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'Which of these interest areas excite you most?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 32),
            // Build the list of selectable interest buttons.
            Expanded(
              child: ListView.builder(
                itemCount: _interests.length,
                itemBuilder: (context, index) {
                  final interest = _interests[index];
                  final isSelected = _selectedInterests.contains(interest);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _onInterestSelected(interest),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.primaryText : AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? AppColors.background : AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // "Continue" button
            ElevatedButton(
              onPressed: _selectedInterests.isNotEmpty ? _onContinuePressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Continue',
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