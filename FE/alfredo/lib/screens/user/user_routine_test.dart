import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRoutineTestPage extends StatelessWidget {
  const UserRoutineTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Routine Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('User routine test content goes here'),
      ),
    );
  }
}
