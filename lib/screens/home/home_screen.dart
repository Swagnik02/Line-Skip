import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_skip/utils/constants.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customLineSkipAppBar(),
      backgroundColor: const Color(0xfffe0c1a4),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Text(FirebaseAuth.instance.currentUser!.phoneNumber!),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, storeSelectionRoute);
              },
              child: const Text('Select Store'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            // No need to navigate manually; AuthPage will update automatically.
          } catch (e) {
            debugPrint('Error signing out: $e');
          }
        },
        child: const Text('Sign Out'),
      ),
    );
  }
}
