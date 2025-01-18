import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/screens/auth/login_screen.dart';
import 'package:line_skip/screens/cart/cart_screen.dart';
import 'package:line_skip/screens/cart/trolley_pairing_screen.dart';
import 'package:line_skip/screens/home/home_screen.dart';
import 'package:line_skip/screens/onboarding/onboarding_screen.dart';
import 'package:line_skip/screens/splash/splash_screen.dart';
import 'package:line_skip/screens/store_selection/store_selection_screen.dart';
import 'package:line_skip/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.appFullName,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange, brightness: Brightness.light),
        brightness: Brightness.light,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: splashRoute,
      routes: {
        splashRoute: (context) => const SplashPage(),
        onboardingRoute: (context) => const OnboardingPage(),
        loginRoute: (context) => const LoginPage(),
        homeRoute: (context) => const HomePage(),
        storeSelectionRoute: (context) => const StoreSelectionPage(),
        cartRoute: (context) => const CartPage(),
        trolleyPairingRoute: (context) => const TrolleyPairingPage(),
      },
    );
  }
}
