import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Add a slight delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (!mounted) return;
      
      if (user == null) {
        // User is not logged in, show onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else {
        // User is logged in, show home page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage(title: 'EcoPulse')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your app logo here
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'EcoPulse',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 