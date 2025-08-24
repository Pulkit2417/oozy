import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'interests_selection_screen.dart'; // Import the next screen

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // A list of available locations to choose from.
  final List<String> _locations = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Chennai',
  ];

  // A Set to store the selected locations. Using a Set is efficient for
  // adding, removing, and checking if an item is selected.
  final Set<String> _selectedLocations = {};

  // This function is called when a location is tapped.
  void _onLocationSelected(String location) {
    setState(() {
      // If the location is already in the selected list, remove it.
      // Otherwise, add it. This toggles the selection.
      if (_selectedLocations.contains(location)) {
        _selectedLocations.remove(location);
      } else {
        _selectedLocations.add(location);
      }
    });
  }

  // This function handles navigation to the next screen.
  void _onNextPressed() {
    // We can pass the selected locations to the next screen if needed.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterestsSelectionScreen(
          selectedLocations: _selectedLocations.toList(),
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
              'Where would you like to meet?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 32),
            // Build the list of selectable location buttons.
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  final location = _locations[index];
                  final isSelected = _selectedLocations.contains(location);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _onLocationSelected(location),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.primaryText : AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        location,
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
            // "Next" button
            ElevatedButton(
              onPressed: _selectedLocations.isNotEmpty ? _onNextPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Next',
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