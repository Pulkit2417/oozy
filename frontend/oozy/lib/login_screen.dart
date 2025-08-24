import 'package:flutter/material.dart';
import 'package:oozy/event_list_screen.dart';
import 'signup_screen.dart';
import 'app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Our "memory boxes" for the text fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // A variable to keep track of any error messages.
  String? _emailErrorText;
  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();
    // Start listening for changes in the text fields right away.
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    // When we're done with the screen, we must clean up our "memory boxes"
    // to prevent any memory leaks.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // A simple front-end validation function for the email.
  void _validateEmail() {
    if (_emailController.text.isNotEmpty && !_emailController.text.contains('@')) {
      setState(() {
        _emailErrorText = 'Please enter a valid email address.';
      });
    } else {
      setState(() {
        _emailErrorText = null;
      });
    }
  }

  // A simple front-end validation function for the password.
  void _validatePassword() {
    if (_passwordController.text.isNotEmpty && _passwordController.text.length < 6) {
      setState(() {
        _passwordErrorText = 'Password must be at least 6 characters long.';
      });
    } else {
      setState(() {
        _passwordErrorText = null;
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
              'Login/Sign up using phone number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.primaryText),
            ),
            const SizedBox(height: 48.0),
            TextFormField(
              controller: _emailController, // This connects our email "memory box"
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryText,
                hintText: 'Email',
                hintStyle: const TextStyle(color: AppColors.background),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: _emailErrorText, // This shows the error message
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.background),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _passwordController, // This connects our password "memory box"
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryText,
                hintText: 'Password',
                hintStyle: const TextStyle(color: AppColors.background),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: _passwordErrorText, // This shows the error message
              ),
              style: const TextStyle(color: AppColors.background),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventListScreen()),
                );
                // Here, we can access the text from our "memory boxes"
                // This is where you would start your backend process.
                final String email = _emailController.text;
                final String password = _passwordController.text;
                print('Attempting to log in with: $email and $password');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Login', style: TextStyle(color: AppColors.background)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text(
                'Sign Up with Phone number',
                style: TextStyle(color: AppColors.primaryText),
              ),
            )
          ],
        ),
      ),
    );
  }
}