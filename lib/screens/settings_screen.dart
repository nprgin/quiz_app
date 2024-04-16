import 'package:flutter/material.dart';
import 'package:quizz_app/components/app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Settings"),
      backgroundColor: Colors.grey[300], // Change screen background color here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for setting game mode
              },
              child: const Text('Choose Game Mode', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for choosing category
              },
              child: const Text('Choose Category', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
