import 'package:flutter/material.dart';
import 'package:oozy/location_selection_screen.dart';
import 'app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // "Memory boxes" for our phone number and OTP.
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // Variables for front-end error messages.
  String? _phoneErrorText;
  String? _otpErrorText;

  @override
  void initState() {
    super.initState();
    // Start listening for changes in the text fields.
    _phoneController.addListener(_validatePhone);
    _otpController.addListener(_validateOtp);
  }

  @override
  void dispose() {
    // Clean up our "memory boxes" when the screen is removed.
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Simple front-end validation for a 10-digit phone number.
  void _validatePhone() {
    final phone = _phoneController.text;
    if (phone.isNotEmpty && phone.length != 10) {
      setState(() {
        _phoneErrorText = 'Phone number must be 10 digits.';
      });
    } else {
      setState(() {
        _phoneErrorText = null;
      });
    }
  }

  // Simple front-end validation for a 6-digit OTP.
  void _validateOtp() {
    final otp = _otpController.text;
    if (otp.isNotEmpty && otp.length != 6) {
      setState(() {
        _otpErrorText = 'OTP must be 6 digits.';
      });
    } else {
      setState(() {
        _otpErrorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'oozy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Login/Sign Up using phone number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.primaryText),
            ),
            const SizedBox(height: 48.0),
            TextFormField(
              controller: _phoneController, // Connect to the phone "memory box"
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryText,
                hintText: 'Phone Number',
                hintStyle: const TextStyle(color: AppColors.background),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: _phoneErrorText, // Show the phone error message
              ),
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.background),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _otpController, // Connect to the OTP "memory box"
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryText,
                hintText: 'OTP',
                hintStyle: const TextStyle(color: AppColors.background),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: _otpErrorText, // Show the OTP error message
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.background),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocationSelectionScreen()),
                );
                // Here, we can access the text from our "memory boxes"
                final String phone = _phoneController.text;
                final String otp = _otpController.text;
                print('Attempting to sign up with: $phone and $otp');
                // TODO: Implement OTP verification and signup logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Sign Up', style: TextStyle(color: AppColors.background)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Login Witth Email',
                style: TextStyle(color: AppColors.primaryText),
              ),
            )
          ],
        ),
      ),
    );
  }
}