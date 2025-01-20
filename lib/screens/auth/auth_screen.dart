import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_skip/screens/home/home_screen.dart';
import 'package:line_skip/screens/splash/splash_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the snapshot has user data (logged in)
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // If no user is logged in, navigate to the LoginPage
            return const SplashPage();
          } else {
            // If user is logged in, navigate to the HomePage
            return const HomePage();
          }
        }

        // While waiting for data, show a loading spinner
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
