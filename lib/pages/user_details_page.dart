import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final String email;
  final String password;

  const UserDetailsPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            const SizedBox(height: 8),
            Text('Password: $password'),
          ],
        ),
      ),
    );
  }
} 