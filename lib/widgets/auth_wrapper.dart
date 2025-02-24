import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../pages/home.dart';
import '../pages/onboarding.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: context.read<AuthService>().authStateChanges,
      builder: (context, snapshot) {
        // Show loading indicator while waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If we have a user, show the home page
        if (snapshot.hasData) {
          return const HomePage(title: 'EcoPulse');
        }

        // Otherwise, show the onboarding screen
        return const OnboardingScreen();
      },
    );
  }
} 