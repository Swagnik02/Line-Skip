import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/utils/constants.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: customLineSkipAppBar(),
      backgroundColor: const Color(0xfffe0c1a4),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, storeSelectionRoute);
              },
              child: const Text('Select Store'),
            ),
          ),
          Text('Welcome, ${user?.name}!',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
          } catch (e) {
            debugPrint('Error signing out: $e');
          }
        },
        child: const Text('Sign Out'),
      ),
    );
  }
}
